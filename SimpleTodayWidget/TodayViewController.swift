//
//  TodayViewController.swift
//  SimpleTodayWidget
//
//  Created by Janak Shah on 06/07/2019.
//  Copyright © 2019 App Ktchn. All rights reserved.
//

import UIKit
import NotificationCenter
import TubeStatusCore

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var label: UILabel!
    let lineVM = LineVM()
    
    let regularFont: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular) as Any]
    let boldFont: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold) as Any]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 13)
        label.textColor = .darkText
        label.text = ""
        label.attributedText = nil
        label.isUserInteractionEnabled = false
        
        let allButton = UIButton()
        allButton.addTarget(self, action: #selector(openApp), for: .touchUpInside)
        view.addSubview(allButton)
        allButton.translatesAutoresizingMaskIntoConstraints = false
        allButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        allButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        allButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        allButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    @objc func openApp() {
        extensionContext?.open(URL(string: "tubeStatus://")! , completionHandler: nil)
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        lineVM.fetchLineStatuses { (error) in
            if let _ = error {
                completionHandler(NCUpdateResult.failed)
                return
            }
            self.updateLabel()
            completionHandler(NCUpdateResult.newData)
        }
    }
    
    func updateLabel() {
        var speak = NSMutableAttributedString(string: "")
        let hasDescriptor = (["minor delays", "severe delays", "no step free access", "issues reported", "no issues"], "has &&&", "have &&&")
        let isPartlyClosed = (["part closure", "part closed"], "is partly closed", "are partly closed")
        let isClosed = (["service closed", "closed"], "is closed", "are closed")
        let specialService = (["special service"], "is operating a special service", "are operating a special service")
        let isDescriptor = (["suspended", "part suspended", "exit only", "diverted", "not running"], "is &&&", "are &&&")
        let hasADescriptor = (["planned closure", "reduced service", "bus service", "change of frequency"], "has a &&&", "have a &&&")
        
        let allTheTuples = [hasDescriptor, isPartlyClosed, isClosed, specialService, isDescriptor, hasADescriptor]
        
        for tuple in allTheTuples {
            for serviceStatus in tuple.0 {
                var lineCollection = [NSAttributedString]()
                
                for line in self.lineVM.allLines {
                    
                    guard let descriptor = line.lineStatuses?.first?.statusSeverityDescription?.lowercased() else { continue }
                    guard let lineName = line.name else { continue }
                    let lineNameAttributed = NSMutableAttributedString(string: lineName, attributes: boldFont)
                    lineNameAttributed.append(NSAttributedString(string: " line", attributes: regularFont))
                    
                    if descriptor == "good service" {
                        continue
                    }
                    
                    if serviceStatus == descriptor {
                        lineCollection.append(lineNameAttributed)
                    }
                    
                }
                
                if lineCollection.isEmpty {
                    continue
                } else if lineCollection.count == 1 {
                    speak.append(NSAttributedString(string: "The ", attributes: regularFont))
                    speak.append(lineCollection.first!)
                    speak.append(NSAttributedString(string: " \(tuple.1.replacingOccurrences(of: "&&&", with: serviceStatus)). ", attributes: regularFont))
                } else if lineCollection.count >= 2 {
                    speak.append(NSAttributedString(string: "The ", attributes: regularFont))
                    let limit = lineCollection.count-2
                    for i in 0..<limit {
                        speak.append(lineCollection[i])
                        speak.append(NSAttributedString(string: ", ", attributes: regularFont))
                    }
                    speak.append(lineCollection[lineCollection.count-2])
                    speak.append(NSAttributedString(string: " and ", attributes: regularFont))
                    speak.append(lineCollection.last!)
                    speak.append(NSAttributedString(string: " \(tuple.2.replacingOccurrences(of: "&&&", with: serviceStatus)). ", attributes: regularFont))
                }
            }
        }
        
        if speak == NSMutableAttributedString(string: "") {
            speak = NSMutableAttributedString(string: "There is a good service on all lines.", attributes: regularFont)
        } else {
            speak.append(NSAttributedString(string: "Good service on all other lines.", attributes: regularFont))
        }
        
        label.attributedText = speak
        
    }
    
}
