//
//  AuctionCell.swift
//  TubeStatus
//
//  Created by Janak Shah on 18/06/2019.
//  Copyright © 2019 App Ktchn. All rights reserved.
//

import UIKit
import TubeStatusCore

class SelectionCell: UITableViewCell {
    
    let label = UILabel()
    let tick = UIImageView()
    
    var line: LineID? {
        didSet {
            if let line = line {
                tick.tintColor = .white
                contentView.backgroundColor = line.colour
                label.textColor = line.textColour
            }
        }
    }

    var chosen: Bool? {
        didSet {
            guard let chosen = chosen else { return }
            tick.image = chosen ? UIImage(named: "ticked") : UIImage(named: "unticked")
            tick.image = tick.image!.withRenderingMode(.alwaysTemplate)
            tick.tintColor = .primaryColour
        }
    }
    
    var labelString: String? {
        didSet {
            guard let labelString = labelString else { return }
            label.text = labelString
            label.textColor = .primaryColour
        }
    }

    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white

        contentView.subviews.forEach({ $0.removeFromSuperview() })
        
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.distribution = .fill
        hStack.alignment = .center
        hStack.spacing = 12
        
        tick.image = UIImage(named: "unticked")
        tick.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        hStack.addArrangedSubview(tick)
        
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        hStack.addArrangedSubview(label)
        
        contentView.addSubview(hStack)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.heightAnchor.constraint(equalToConstant: 44).isActive = true
        hStack.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        hStack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        hStack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
