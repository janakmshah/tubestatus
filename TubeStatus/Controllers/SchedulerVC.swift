//
//  StatusListVC.swift
//  TubeStatus
//
//  Created by Janak Shah on 21/06/2019.
//  Copyright © 2019 App Ktchn. All rights reserved.
//

import UIKit

class SchedulerVC: UITableViewController {

    var remindersArray = [ReminderVM]()
    var savedArray = [ReminderVM]()
    
    enum Sections: Int, CaseIterable {
        case example
        case reminders
        case addReminder
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        loadSchedule()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @objc fileprivate func loadSchedule() {

    }
    
    fileprivate func setupTableView() {
        tableView.register(ReminderCell.self, forCellReuseIdentifier: String(describing: ReminderCell.self))
        tableView.register(SwipeExampleCell.self, forCellReuseIdentifier: String(describing: SwipeExampleCell.self))
        tableView.separatorStyle = .none
        tableView.backgroundColor = .primaryBGColour
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.tableFooterView = UIView()
        tableView.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(loadSchedule), for: .valueChanged)
        refreshControl?.tintColor = .secondaryColour
    }
    
    fileprivate func setupNavBar() {
        navigationItem.title = "Daily Alerts"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .primaryBGColour
        navigationController?.navigationBar.tintColor = .secondaryColour
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.secondaryColour]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.secondaryColour]
    }
    

    
    // MARK: - Tableview
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Sections(rawValue: section) {
        case .example?:
            return 1
        case .reminders?:
            return remindersArray.count
        case .addReminder?:
            return 1
        case .none:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch Sections(rawValue: section) {
        case .example?:
            return 0
        case .reminders?:
            return 12
        case .addReminder?:
            return 12
        case .none:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch Sections(rawValue: indexPath.section) {
        case .example?:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SwipeExampleCell.self),
                                                           for: indexPath) as? SwipeExampleCell else { return UITableViewCell() }
            cell.setupCell()
            return cell
        case .reminders?:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ReminderCell.self),
                                                           for: indexPath) as? ReminderCell else { return UITableViewCell() }
            cell.reminder = remindersArray[indexPath.row]
            return cell
        case .addReminder?:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ReminderCell.self),
                                                           for: indexPath) as? ReminderCell else { return UITableViewCell() }
            cell.reminder = ReminderVM(days: [], time: "New timed alert", lines: [], id: UUID().uuidString)
            return cell
        case .none:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Sections(rawValue: indexPath.section) {
        case .example?:
            return
        case .reminders?:
            self.present(UINavigationController(rootViewController: CreateReminderVC(reminder: remindersArray[indexPath.row], new: false)), animated: true)
        case .addReminder?:
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "HH:mm"
            let newReminder = ReminderVM(days: [.Monday, .Tuesday, .Wednesday, .Thursday, .Friday], time: formatter.string(from: Date()), lines: [], id: UUID().uuidString)
            self.present(UINavigationController(rootViewController: CreateReminderVC(reminder: newReminder, new: true)), animated: true)
        case .none:
            return
        }
        
    }
    
}
