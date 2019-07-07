//
//  StatusListVC.swift
//  TubeStatus
//
//  Created by Janak Shah on 21/06/2019.
//  Copyright © 2019 App Ktchn. All rights reserved.
//

import UIKit

class SchedulerVC: UITableViewController {

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
            return 1
        case .addReminder?:
            return 1
        case .none:
            return 0
        }
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
            return cell
        case .addReminder?:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ReminderCell.self),
                                                           for: indexPath) as? ReminderCell else { return UITableViewCell() }
            return cell
        case .none:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

}
