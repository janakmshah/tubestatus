//
//  SwipeExampleCell.swift
//  TubeStatus
//
//  Created by Janak Shah on 23/06/2019.
//  Copyright © 2019 App Ktchn. All rights reserved.
//

import UIKit

class SwipeExampleCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        selectionStyle = .none
        self.backgroundColor = .clear
        contentView.backgroundColor = .secondaryColour
        
        contentView.subviews.forEach({ $0.removeFromSuperview() })
        
        let containerView = UIView()
        containerView.backgroundColor = .primaryBGColour
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
        
        let reason = UILabel()
        reason.text = "Swipe to add favourites:"
        reason.numberOfLines = 0
        reason.font = .systemFont(ofSize: 20, weight: .bold)
        reason.textColor = .secondaryColour
        reason.textAlignment = .left
        
        let exampleImage = UIImageView()
        exampleImage.image = UIImage(named: "swipeExample")
        exampleImage.contentMode = .scaleAspectFit
        
        let button = UIButton()
        button.backgroundColor = .primaryColour
        button.setTitle("Ok, got it!", for: .normal)
        button.titleLabel?.font =  .systemFont(ofSize: 17, weight: .bold)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.isUserInteractionEnabled = false
        
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.distribution = .equalSpacing
        vStack.alignment = .fill
        vStack.spacing = 4
        vStack.addArrangedSubview(reason)
        vStack.addArrangedSubview(exampleImage)
        vStack.addArrangedSubview(button)
        
        containerView.addSubview(vStack)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive = true
        vStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8).isActive = true
        vStack.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        vStack.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8).isActive = true
        
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        containerView.widthAnchor.constraint(lessThanOrEqualToConstant: 320).isActive = true
    }

}
