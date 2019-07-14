//
//  AuctionCell.swift
//  TubeStatus
//
//  Created by Janak Shah on 18/06/2019.
//  Copyright © 2019 App Ktchn. All rights reserved.
//

import UIKit
import TubeStatusCore

class DaySelectCell: UITableViewCell {

    // MARK: - Initialization
    var reminderDays: [DayOfWeek]? {
        didSet {
            guard let reminderDays = reminderDays else { return }
            contentView.subviews.forEach({ $0.removeFromSuperview() })
            let collectionView = DaysCollectionView(reminderDays: reminderDays)
            contentView.addSubview(collectionView)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
            collectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
            collectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
