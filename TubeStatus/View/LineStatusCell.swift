//
//  AuctionCell.swift
//  TubeStatus
//
//  Created by Janak Shah on 18/06/2019.
//  Copyright © 2019 App Ktchn. All rights reserved.
//

import UIKit
import TubeStatusCore

class LineStatusCell: UITableViewCell {

    // MARK: - Properties
    var favourite = false
    var line: Line! {
        didSet {
            contentView.subviews.forEach({ $0.removeFromSuperview() })
            
//            var statusSet = Set<String>()
//            for lineStatus in (line?.lineStatuses ?? []) {
//                if let reason = lineStatus.prettyReason {
//                    statusSet.insert(reason)
//                }
//            }
//
//            for status in statusSet {
//                let reason = UILabel()
//                reason.text = status
//                reason.numberOfLines = 0
//                reason.font = .systemFont(ofSize: 15, weight: .medium)
//                reason.textColor = line.textColour
//                reason.textAlignment = .left
//                vStack.addArrangedSubview(reason)
//            }

            let vStack = UIStackView()
            vStack.axis = .vertical
            vStack.distribution = .equalSpacing
            vStack.alignment = .fill
            vStack.spacing = 4
            vStack.addArrangedSubview(horizontalLabelStack(stringTuple: ("\(favourite ? "★ " : "")\(line.name ?? "")", line.lineStatuses?.first?.statusSeverityDescription ?? "")))
            
            let reason = UILabel()
            reason.text = line.lineStatuses?.first?.prettyReason
            reason.numberOfLines = 0
            reason.font = .systemFont(ofSize: 15, weight: .medium)
            reason.textColor = line.textColour
            reason.textAlignment = .left
            if reason.text != nil { vStack.addArrangedSubview(reason) }
            
            let roundedView = UIView()
            //roundedView.layer.cornerRadius = 4
            roundedView.clipsToBounds = true
            roundedView.backgroundColor = line.mainColour
            
            contentView.addSubview(roundedView)
            roundedView.translatesAutoresizingMaskIntoConstraints = false
            roundedView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
            roundedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
            roundedView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
            roundedView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
            
            roundedView.addSubview(vStack)
            vStack.translatesAutoresizingMaskIntoConstraints = false
            vStack.topAnchor.constraint(equalTo: roundedView.topAnchor, constant: 16).isActive = true
            vStack.bottomAnchor.constraint(equalTo: roundedView.bottomAnchor, constant: -16).isActive = true
            vStack.leftAnchor.constraint(equalTo: roundedView.leftAnchor, constant: 16).isActive = true
            vStack.rightAnchor.constraint(equalTo: roundedView.rightAnchor, constant: -16).isActive = true
        }
    }
    
    func horizontalLabelStack(stringTuple: (String?, String?)) -> UIStackView {
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.distribution = .equalSpacing
        hStack.alignment = .center
        hStack.spacing = 8

        let label = UILabel()
        label.text = stringTuple.0
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = line.textColour
        label.numberOfLines = 0
        hStack.addArrangedSubview(label)

        let value = UILabel()
        value.text = stringTuple.1
        value.textAlignment = .left
        value.font = .systemFont(ofSize: 15, weight: .bold)
        value.textColor = .secondaryColour
        value.numberOfLines = 0
        
        let roundedView = UIView()
        roundedView.layer.cornerRadius = 14
        roundedView.clipsToBounds = true
        roundedView.backgroundColor = .white
        
        roundedView.addSubview(value)
        value.translatesAutoresizingMaskIntoConstraints = false
        value.topAnchor.constraint(equalTo: roundedView.topAnchor, constant: 6).isActive = true
        value.bottomAnchor.constraint(equalTo: roundedView.bottomAnchor, constant: -6).isActive = true
        value.leftAnchor.constraint(equalTo: roundedView.leftAnchor, constant: 12).isActive = true
        value.rightAnchor.constraint(equalTo: roundedView.rightAnchor, constant: -12).isActive = true
        hStack.addArrangedSubview(roundedView)

        return hStack
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
