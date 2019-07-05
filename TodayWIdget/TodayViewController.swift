//
//  TodayViewController.swift
//  TodayWIdget
//
//  Created by Janak Shah on 05/07/2019.
//  Copyright © 2019 App Ktchn. All rights reserved.
//

import UIKit
import NotificationCenter
import TubeStatusCore

class TodayViewController: UIViewController, NCWidgetProviding {
    
    var lineVM = LineVM()
    var vStack = UIStackView()
    var bottomButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        addButtonToBottom()
        
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    func updateViews() {
        vStack.removeFromSuperview()
        vStack = UIStackView()
        vStack.axis = .vertical
        vStack.distribution = .equalSpacing
        vStack.alignment = .fill
        vStack.spacing = 0
        
        var arrayDicts = [String:[String]]()
        
        for line in self.lineVM.allLines {
            guard let statusDescriptor = line.lineStatuses?.first?.statusSeverityDescription else { continue }
            guard let lineName = line.name else { continue }
            if statusDescriptor.lowercased() == "good service" { continue }
            arrayDicts[statusDescriptor] = (arrayDicts[statusDescriptor] ?? []) + [lineName]
        }
        
        for dict in arrayDicts {
            vStack.addArrangedSubview(self.horizontalLabelStack(stringTuple: (dict.value.joined(separator: ", "), dict.key)))
        }
        
        vStack.addArrangedSubview(self.horizontalLabelStack(stringTuple: (arrayDicts.count == 0 ? "All lines" : "All Other Lines", "Good Service")))
        
        self.view.addSubview(vStack)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        vStack.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        vStack.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        view.addSubview(bottomButton)
        bottomButton.translatesAutoresizingMaskIntoConstraints = false
        bottomButton.topAnchor.constraint(equalTo: vStack.bottomAnchor, constant: 6).isActive = true
        bottomButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        lineVM.fetchLineStatuses { [weak self] (error) in
            if let _ = error {
                completionHandler(NCUpdateResult.failed)
                return
            }
            guard let self = self else {
                completionHandler(NCUpdateResult.failed)
                return
            }
            self.updateViews()
            completionHandler(NCUpdateResult.newData)
        }
        
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let expanded = activeDisplayMode == .expanded
        bottomButton.isHidden = !expanded
        preferredContentSize = expanded ? CGSize(width: maxSize.width, height: 500) : maxSize
    }
    
    private func addButtonToBottom() {
        let value = UILabel()
        value.text = "Further details"
        value.textAlignment = .left
        value.font = .systemFont(ofSize: 14, weight: .bold)
        value.textColor = .secondaryColour
        value.numberOfLines = 0
        value.isUserInteractionEnabled = false
        
        bottomButton = UIButton()
        bottomButton.layer.cornerRadius = 10
        bottomButton.clipsToBounds = true
        bottomButton.backgroundColor = .white
        
        bottomButton.addSubview(value)
        value.translatesAutoresizingMaskIntoConstraints = false
        value.topAnchor.constraint(equalTo: bottomButton.topAnchor, constant: 3).isActive = true
        value.bottomAnchor.constraint(equalTo: bottomButton.bottomAnchor, constant: -3).isActive = true
        value.leftAnchor.constraint(equalTo: bottomButton.leftAnchor, constant: 12).isActive = true
        value.rightAnchor.constraint(equalTo: bottomButton.rightAnchor, constant: -12).isActive = true
    }
    
    func horizontalLabelStack(stringTuple: (String?, String?)) -> UIView {
        let hStack = UIStackView()
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.axis = .horizontal
        hStack.distribution = .equalSpacing
        hStack.alignment = .center
        hStack.spacing = 8
        
        let label = UILabel()
        label.text = stringTuple.0
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .secondaryColour
        label.numberOfLines = 0
        hStack.addArrangedSubview(label)
        
        let value = UILabel()
        value.text = stringTuple.1
        value.textAlignment = .left
        value.font = .systemFont(ofSize: 14, weight: .bold)
        value.textColor = .secondaryColour
        value.numberOfLines = 0
        
        let roundedView = UIView()
        roundedView.layer.cornerRadius = 10
        roundedView.clipsToBounds = true
        roundedView.backgroundColor = .white
        
        roundedView.addSubview(value)
        value.translatesAutoresizingMaskIntoConstraints = false
        value.topAnchor.constraint(equalTo: roundedView.topAnchor, constant: 3).isActive = true
        value.bottomAnchor.constraint(equalTo: roundedView.bottomAnchor, constant: -3).isActive = true
        value.leftAnchor.constraint(equalTo: roundedView.leftAnchor, constant: 12).isActive = true
        value.rightAnchor.constraint(equalTo: roundedView.rightAnchor, constant: -12).isActive = true
        hStack.addArrangedSubview(roundedView)
        
        let containerView = UIView()
        containerView.addSubview(hStack)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: hStack.topAnchor, constant: -6).isActive = true
        containerView.bottomAnchor.constraint(equalTo: hStack.bottomAnchor, constant: 6).isActive = true
        containerView.leftAnchor.constraint(equalTo: hStack.leftAnchor, constant: -8).isActive = true
        containerView.rightAnchor.constraint(equalTo: hStack.rightAnchor, constant: 8).isActive = true
        
        return containerView
    }
    
}
