//
//  TimerCell.swift
//  TubeStatus
//
//  Created by Janak Shah on 23/06/2019.
//  Copyright © 2019 App Ktchn. All rights reserved.
//

import UIKit

class TimerCell: UITableViewCell {

    var headerLabel = UILabel()
    weak var timer: Timer?
    weak var lineVM: LineVM! {
        didSet {
            timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.refresh), userInfo: nil, repeats: true)
            
            headerLabel.text = lineVM.prettyLastUpdated
            headerLabel.font = .systemFont(ofSize: 13, weight: .semibold)
            headerLabel.textColor = .secondaryColour
            headerLabel.numberOfLines = 0
            
            contentView.addSubview(headerLabel)
            headerLabel.translatesAutoresizingMaskIntoConstraints = false
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
            headerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3).isActive = true
            headerLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
            headerLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        }
    }
    
    @objc func refresh() {
        headerLabel.text = lineVM.prettyLastUpdated
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

}
