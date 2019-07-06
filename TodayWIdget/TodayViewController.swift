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
    
    let lineVM = LineVM()
    let vStack = UIStackView()
    let bottomButton = UIButton()
    let allButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        addButtonToBottom()
        
        allButton.addTarget(self, action: #selector(openApp), for: .touchUpInside)
        view.addSubview(allButton)
        allButton.translatesAutoresizingMaskIntoConstraints = false
        allButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        allButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        allButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        allButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    func updateViews() {
        vStack.removeFromSuperview()
        vStack.axis = .vertical
        vStack.distribution = .equalSpacing
        vStack.alignment = .fill
        vStack.spacing = 0
        
        for line in self.lineVM.favouriteLines {
            guard let statusDescriptor = line.lineStatuses?.first?.statusSeverityDescription else { continue }
            guard var lineName = line.name else { continue }
            
            if UIScreen.main.bounds.size.width <= 375 {
                if lineName == "London Overground" { lineName = "Overground" }
                if lineName == "Hammersmith & City" { lineName = "Hamrsth & City" }
            }
            lineName = "★ " + lineName
            vStack.addArrangedSubview(self.horizontalLabelStack(stringTuple: (lineName, statusDescriptor), line: line))
        }
        
        for line in self.lineVM.standardLines {
            guard let statusDescriptor = line.lineStatuses?.first?.statusSeverityDescription else { continue }
            guard var lineName = line.name else { continue }
            
            if UIScreen.main.bounds.size.width <= 375 {
                if lineName == "London Overground" { lineName = "Overground" }
                if lineName == "Hammersmith & City" { lineName = "Hamrsth & City" }
            }
            vStack.addArrangedSubview(self.horizontalLabelStack(stringTuple: (lineName, statusDescriptor), line: line))
        }
        
        self.view.addSubview(vStack)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        vStack.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        vStack.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        view.bringSubviewToFront(bottomButton)
        view.bringSubviewToFront(allButton)
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
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
        preferredContentSize = expanded ? CGSize(width: maxSize.width, height: 486) : maxSize
    }
    
    private func addButtonToBottom() {
        bottomButton.backgroundColor = .white
        bottomButton.setTitle("• Further details", for: .normal)
        bottomButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        bottomButton.setTitleColor(.secondaryColour, for: .normal)
        bottomButton.isUserInteractionEnabled = false
        
        view.addSubview(bottomButton)
        bottomButton.translatesAutoresizingMaskIntoConstraints = false
        bottomButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }
    
    @objc func openApp() {
        extensionContext?.open(URL(string: "tubeStatus://")! , completionHandler: nil)
    }
    
    func horizontalLabelStack(stringTuple: (String?, String?), line: Line) -> UIView {
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
        label.textColor = line.textColour
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
        containerView.backgroundColor = line.mainColour
        
        return containerView
    }
    
}
