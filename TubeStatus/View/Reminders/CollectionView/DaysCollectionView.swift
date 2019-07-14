//
//  DaysCollectionView.swift
//  TubeStatus
//
//  Created by Janak Shah on 13/07/2019.
//  Copyright © 2019 App Ktchn. All rights reserved.
//

import UIKit

class DaysCollectionView: UICollectionView {

    let reminder: ReminderVM
    
    let overallHSpace: CGFloat = 16
    let interHSpace: CGFloat = 8
    let interVSpace: CGFloat = 8
    
    init(reminder: ReminderVM) {
        self.reminder = reminder
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 80), collectionViewLayout: UICollectionViewFlowLayout())
        self.customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func customInit() {
        
        dataSource = self
        delegate = self
        clipsToBounds = false
        register(UINib(nibName: "DaysViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: String(describing: DaysViewCell.self))
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        backgroundColor = .clear
        
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = interVSpace
        layout.minimumInteritemSpacing = interHSpace
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = CGSize(width: 50, height: 50)
        
        collectionViewLayout = layout
        
        var numberOfLines: CGFloat = 1
        var runningWidth: CGFloat = 0
        for string in DayOfWeek.allCases {
            let spaceNeeded: CGFloat = itemSizeFor(string: string.rawValue).width + interHSpace
            let previousSpace = runningWidth + overallHSpace
            if (spaceNeeded + previousSpace) > UIScreen.main.bounds.size.width {
                numberOfLines += 1
                runningWidth = spaceNeeded - interHSpace
            } else {
                runningWidth += spaceNeeded
            }
        }
        
        let heightOfItems = (itemSizeFor(string: "Monday").height) * numberOfLines
        let heightOfSpaces = interVSpace * (numberOfLines - 1)
        self.heightAnchor.constraint(equalToConstant: heightOfItems+heightOfSpaces).isActive = true
        
    }
    
    private func itemSizeFor(string: String) -> CGSize {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.text = string
        label.sizeToFit()
        return CGSize(width: min(label.bounds.size.width+12,UIScreen.main.bounds.size.width-overallHSpace), height: label.bounds.size.height+12)
    }
}

extension DaysCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: String(describing: DaysViewCell.self),
                                                       for: indexPath) as? DaysViewCell else { return UICollectionViewCell() }
        let dayOfWeek = DayOfWeek.allCases[indexPath.row]
        cell.label.text = dayOfWeek.rawValue
        if reminder.days.contains(dayOfWeek) {
            cell.container.backgroundColor = .primaryColour
            cell.label.textColor = .white
        } else {
            cell.container.backgroundColor = .groupTableViewBackground
            cell.label.textColor = .lightGray
        }

        return cell

    }
}

extension DaysCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dayOfWeek = DayOfWeek.allCases[indexPath.row]
        if let index = reminder.days.firstIndex(of: dayOfWeek) {
            reminder.days.remove(at: index)
        } else {
            reminder.days.append(dayOfWeek)
            reminder.days = reminder.days.sorted{ DayOfWeek.allCases.firstIndex(of: $0)! < DayOfWeek.allCases.firstIndex(of: $1)! }
        }
        self.reloadData()
    }
}

extension DaysCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSizeFor(string: DayOfWeek.allCases[indexPath.row].rawValue)
    }
}

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        
        return attributes
    }
}
