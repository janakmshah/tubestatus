//
//  StatusListVC.swift
//  TubeStatus
//
//  Created by Janak Shah on 21/06/2019.
//  Copyright © 2019 App Ktchn. All rights reserved.
//

import UIKit
import TubeStatusCore

class CreateReminderVC: UITableViewController {

    var days: [DayOfWeek]
    var time: String
    var lines: [LineID]
    
    enum Sections: Int, CaseIterable {
        case time
        case days
        case lines
    }

    init(reminder: ReminderVM, new: Bool) {
        self.days = reminder.days
        self.lines = reminder.lines
        self.time = reminder.time
        super.init(nibName: nil, bundle: nil)
        self.title = new ? "Add new alert" : "Edit alert"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        loadSchedule()
    }
    
    @objc fileprivate func loadSchedule() {
        tableView.reloadData()
    }
    
    fileprivate func setupTableView() {
        tableView.register(LineSelectCell.self, forCellReuseIdentifier: String(describing: LineSelectCell.self))
        tableView.register(DaySelectCell.self, forCellReuseIdentifier: String(describing: DaySelectCell.self))
        tableView.register(TimeSelectCell.self, forCellReuseIdentifier: String(describing: TimeSelectCell.self))
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
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .primaryBGColour
        navigationController?.navigationBar.tintColor = .secondaryColour
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.secondaryColour]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.secondaryColour]
        self.navigationItem.leftBarButtonItem = btnClose
        self.navigationItem.rightBarButtonItem = btnSave
    }
    
    lazy var btnClose: UIBarButtonItem = {
        return UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(closeAction))
    }()
    
    @objc func closeAction() {
        dismiss(animated: true, completion: nil)
    }
    
    lazy var btnSave: UIBarButtonItem = {
        return UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveAction))
    }()
    
    @objc func saveAction() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Tableview
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Sections(rawValue: section) {
        case .time?:
            return 1
        case .days?:
            return 1
        case .lines?:
            return LineID.allCases.count
        case .none:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch Sections(rawValue: section) {
        case .time?:
            return 24
        case .days?:
            return 24
        case .lines?:
            return 24
        case .none:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch Sections(rawValue: indexPath.section) {
        case .time?:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TimeSelectCell.self),
                                                           for: indexPath) as? TimeSelectCell else { return UITableViewCell() }
            cell.timeString = self.time
            return cell
        case .days?:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DaySelectCell.self),
                                                           for: indexPath) as? DaySelectCell else { return UITableViewCell() }
            cell.reminderDays = days
            return cell
        case .lines?:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LineSelectCell.self),
                                                           for: indexPath) as? LineSelectCell else { return UITableViewCell() }
            cell.labelString = LineID.allCases[indexPath.row].stringValue
            cell.chosen = lines.contains(LineID.allCases[indexPath.row])
            cell.line = LineID.allCases[indexPath.row]
            return cell
        case .none:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Sections(rawValue: indexPath.section) {
        case .time?:
            return
        case .days?:
            return
        case .lines?:
            if let index = lines.firstIndex(of: LineID.allCases[indexPath.row]) {
                lines.remove(at: index)
            } else {
                lines.append(LineID.allCases[indexPath.row])
            }
        case .none:
            return
        }
        tableView.reloadRows(at: [indexPath], with: .fade)
    }

}
