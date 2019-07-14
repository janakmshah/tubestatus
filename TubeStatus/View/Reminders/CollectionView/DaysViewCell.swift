//
//  DaysViewCell.swift
//  TubeStatus
//
//  Created by Janak Shah on 13/07/2019.
//  Copyright © 2019 App Ktchn. All rights reserved.
//

import UIKit

class DaysViewCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var container: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        container.clipsToBounds = true
        container.backgroundColor = .primaryColour
        container.layer.cornerRadius = 4
    }

}
