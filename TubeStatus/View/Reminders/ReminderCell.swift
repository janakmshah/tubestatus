//
//  AuctionCell.swift
//  TubeStatus
//
//  Created by Janak Shah on 18/06/2019.
//  Copyright © 2019 App Ktchn. All rights reserved.
//

import UIKit

class ReminderCell: UITableViewCell {
    
    var reminder: ReminderVM? {
        didSet {
            
            guard let reminder = reminder else { return }
            
            contentView.subviews.forEach({ $0.removeFromSuperview() })
            
            let hStack = UIStackView()
            hStack.axis = .horizontal
            hStack.distribution = .fill
            hStack.alignment = .center
            hStack.spacing = 12
            
            let label = UILabel()
            label.text = reminder.time == "New timed alert" ? "➕" : "🕗"
            label.textAlignment = .left
            label.font = .systemFont(ofSize: 17, weight: .medium)
            label.textColor = .primaryColour
            label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            hStack.addArrangedSubview(label)
            
            let vStack = UIStackView()
            vStack.axis = .vertical
            vStack.distribution = .equalSpacing
            vStack.alignment = .leading
            vStack.spacing = 0
            vStack.setContentHuggingPriority(.defaultLow, for: .horizontal)
            hStack.addArrangedSubview(vStack)
            
//            if reminder.time != "New timed alert" {
//                let switchUI = UISwitch()
//                switchUI.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//                hStack.addArrangedSubview(switchUI)
//            }
            
            let time = UILabel()
            time.text = reminder.time
            time.textAlignment = .left
            time.font = .systemFont(ofSize: 15, weight: .medium)
            time.textColor = .primaryColour
            vStack.addArrangedSubview(time)
            
            let days = UILabel()
            days.text = daysDisplayName
            days.textAlignment = .left
            days.font = .systemFont(ofSize: 13, weight: .medium)
            days.textColor = .lightGray
            days.numberOfLines = 0
            vStack.addArrangedSubview(days)
                        
            let lines = UILabel()
            lines.text = reminder.lines.map({$0.stringValue}).joined(separator: ", ")
            lines.textAlignment = .left
            lines.font = .systemFont(ofSize: 13, weight: .medium)
            lines.textColor = .lightGray
            lines.numberOfLines = 0
            vStack.addArrangedSubview(lines)
            
            contentView.backgroundColor = .white
            contentView.addSubview(hStack)
            hStack.translatesAutoresizingMaskIntoConstraints = false
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
            hStack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
            hStack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        }
    }

    var daysDisplayName: String {
        guard let reminder = reminder else { return "" }
        
        if reminder.days == [.Monday, .Tuesday, .Wednesday, .Thursday, .Friday, .Saturday, .Sunday] {
            return "Everyday"
        } else if reminder.days == [.Monday, .Tuesday, .Wednesday, .Thursday, .Friday] {
            return "Weekdays"
        } else if reminder.days == [.Saturday, .Sunday] {
            return "Weekends"
        } else {
            return reminder.days.map({$0.rawValue}).joined(separator: ", ")
        }
    }
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
