//
//  StatusListVC.swift
//  TubeStatus
//
//  Created by Janak Shah on 21/06/2019.
//  Copyright © 2019 App Ktchn. All rights reserved.
//

import UIKit
import CoreSpotlight
import Intents
import IntentsUI
import MobileCoreServices
import TubeStatusCore

public let kViewStatusActivityType = "com.appktchn.TubeStatus.ViewStatus"

class StatusListVC: UITableViewController, Refreshable {

    enum Sections: Int, CaseIterable {
        case example
        case timer
        case favouriteLines
        case standardLines
    }
    
    var lineVM = LineVM()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        loadStatuses()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refresh()
    }
    
    @objc fileprivate func loadStatuses() {
        let activity = viewStatusShortcut()
        self.userActivity = activity
        activity.becomeCurrent()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        lineVM.loadAuctions(from: self, hideSpinner: {
            MBProgressHUD.hide(for: self.view, animated: true)
        })
    }
    
    @objc func refresh() {
        refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
    fileprivate func setupTableView() {
        tableView.register(LineStatusCell.self, forCellReuseIdentifier: String(describing: LineStatusCell.self))
        tableView.register(TimerCell.self, forCellReuseIdentifier: String(describing: TimerCell.self))
        tableView.register(SwipeExampleCell.self, forCellReuseIdentifier: String(describing: SwipeExampleCell.self))
        tableView.separatorStyle = .none
        tableView.backgroundColor = .primaryBGColour
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.tableFooterView = UIView()
        tableView.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(loadStatuses), for: .valueChanged)
        refreshControl?.tintColor = .secondaryColour
    }
    
    fileprivate func setupNavBar() {
        navigationItem.title = "Tube Status"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .primaryBGColour
        navigationController?.navigationBar.tintColor = .secondaryColour
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.secondaryColour]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.secondaryColour]
    }
    
    func viewStatusShortcut() -> NSUserActivity {
        let activity = NSUserActivity(activityType: kViewStatusActivityType)
        activity.persistentIdentifier = NSUserActivityPersistentIdentifier(kViewStatusActivityType)
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        
        let attributes = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)
        activity.title = "Check tube status"
        attributes.contentDescription = "Check london underground for delays and service disruptions"
        activity.suggestedInvocationPhrase = "Check tube status"
        activity.contentAttributeSet = attributes

        return activity
    }

    
    // MARK: - Tableview
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Sections(rawValue: section) {
        case .example?:
            let defaults = UserDefaults.standard
            return defaults.string(forKey: "seenSwipeExample") == nil ? 1 : 0;
        case .timer?:
            return lineVM.favouriteLines.isEmpty && lineVM.standardLines.isEmpty ? 0 : 1;
        case .favouriteLines?:
            return lineVM.favouriteLines.count
        case .standardLines?:
            return lineVM.standardLines.count
        case .none:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch Sections(rawValue: section) {
        case .example?:
            fallthrough
        case .timer?:
            fallthrough
        case .favouriteLines?:
            fallthrough
        case .none:
            return 0
        case .standardLines?:
            return 60
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch Sections(rawValue: indexPath.section) {
        case .example?:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SwipeExampleCell.self),
                                                           for: indexPath) as? SwipeExampleCell else { return UITableViewCell() }
            return cell
        case .timer?:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TimerCell.self),
                                                           for: indexPath) as? TimerCell else { return UITableViewCell() }
            cell.lineVM = lineVM
            return cell
        case .favouriteLines?:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LineStatusCell.self),
                                                           for: indexPath) as? LineStatusCell else { return UITableViewCell() }
            cell.favourite = true
            cell.line = lineVM.favouriteLines[indexPath.row]
            return cell
        case .standardLines?:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LineStatusCell.self),
                                                           for: indexPath) as? LineStatusCell else { return UITableViewCell() }
            cell.favourite = false
            cell.line = lineVM.standardLines[indexPath.row]
            return cell
        case .none:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == Sections.example.rawValue {
            let defaults = UserDefaults.standard
            defaults.set("seenSwipeExample", forKey: "seenSwipeExample")
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .bottom)
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        if indexPath.section == Sections.example.rawValue { return UISwipeActionsConfiguration(actions: []) }
        if indexPath.section == Sections.timer.rawValue { return UISwipeActionsConfiguration(actions: []) }
        
        let favourite = indexPath.section == Sections.favouriteLines.rawValue
        let array = favourite ? lineVM.favouriteLines : lineVM.standardLines
        let lineID = array[indexPath.row].id
        
        let title = favourite ? "Unfavorite" : "Favorite"
        
        let action = UIContextualAction(style: .normal, title: title,
                                        handler: { (action, view, completionHandler) in
                                            if favourite {
                                                self.lineVM.removeFromFaves(lineID: lineID)
                                            } else {
                                                self.lineVM.addToFaves(lineID: lineID)
                                            }
                                            self.tableView.reloadSections(IndexSet(integersIn: Sections.favouriteLines.rawValue...Sections.standardLines.rawValue), with: .fade)
                                            completionHandler(true)
        })
        
        action.image = favourite ? UIImage(named: "delete") : UIImage(named: "star")
        action.backgroundColor = array[indexPath.row].mainColour
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard section == Sections.standardLines.rawValue else {
            return UIView()
        }
        
        let button = INUIAddVoiceShortcutButton(style: .whiteOutline)
        setupShortcut(on: button)
        
        let footerView = UIView()
        footerView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        
        return footerView
    }
    
    func setupShortcut(on button: INUIAddVoiceShortcutButton) {
        button.shortcut = INShortcut(userActivity: viewStatusShortcut())
        button.delegate = self
    }

}

extension StatusListVC: INUIAddVoiceShortcutViewControllerDelegate {
    func addVoiceShortcutViewController(
        _ controller: INUIAddVoiceShortcutViewController,
        didFinishWith voiceShortcut: INVoiceShortcut?,
        error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
    func addVoiceShortcutViewControllerDidCancel(
        _ controller: INUIAddVoiceShortcutViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension StatusListVC: INUIAddVoiceShortcutButtonDelegate {
    func present(_ addVoiceShortcutViewController: INUIAddVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        addVoiceShortcutViewController.delegate = self
        addVoiceShortcutViewController.modalPresentationStyle = .formSheet
        present(addVoiceShortcutViewController, animated: true, completion: nil)
    }
    
    func present(_ editVoiceShortcutViewController: INUIEditVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        editVoiceShortcutViewController.delegate = self
        editVoiceShortcutViewController.modalPresentationStyle = .formSheet
        present(editVoiceShortcutViewController, animated: true, completion: nil)
    }
}

extension StatusListVC: INUIEditVoiceShortcutViewControllerDelegate {
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
