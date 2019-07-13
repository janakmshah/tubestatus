//
//  AuctionCell.swift
//  TubeStatus
//
//  Created by Janak Shah on 18/06/2019.
//  Copyright © 2019 App Ktchn. All rights reserved.
//

import UIKit

class TimeSelectCell: UITableViewCell {
    
    let picker = UIDatePicker()
    
    var reminder: ReminderVM? {
        didSet {
            guard let reminder = reminder else { return }
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "HH:mm"
            picker.date = formatter.date(from: reminder.time) ?? Date()
        }
    }

    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        contentView.subviews.forEach({ $0.removeFromSuperview() })
        picker.datePickerMode = .time
        picker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        contentView.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.heightAnchor.constraint(equalToConstant: 150).isActive = true
        picker.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        picker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        picker.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        picker.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        guard let reminder = reminder else { return }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "HH:mm"
        reminder.time = formatter.string(from: sender.date)
    }
}
