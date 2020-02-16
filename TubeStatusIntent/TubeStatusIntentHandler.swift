//
//  TubeStatusIntentHandler.swift
//  TubeStatusIntent
//
//  Created by Janak Shah on 29/06/2019.
//  Copyright © 2019 App Ktchn. All rights reserved.
//

import Foundation
import TubeStatusCore

class TubeStatusIntentHandler: NSObject, TubeStatusIntentHandling {
    
    var lineVM = LineVM()
    
    func handle(intent: TubeStatusIntent, completion: @escaping (TubeStatusIntentResponse) -> Void) {
        
        lineVM.fetchLineStatuses { (error) in
            if let error = error {
                completion(TubeStatusIntentResponse.failure(fetchError: error.localizedDescription))
                return
            }
            
//            let testArray = [("Jubilee", "suspended"), ("Central", "suspended"), ("District", "suspended"), ("Circle", "suspended"), ("Northern", "severe delays"), ("Metropolitan", "severe delays")]
            
            var speak = ""
            let hasDescriptor = (["minor delays", "severe delays", "no step free access", "issues reported", "no issues"], "has &&&", "have &&&")
            let isPartlyClosed = (["part closure", "part closed"], "is partly closed", "are partly closed")
            let isClosed = (["service closed", "closed"], "is closed", "are closed")
            let specialService = (["special service"], "is operating a special service", "are operating a special service")
            let isDescriptor = (["suspended", "part suspended", "exit only", "diverted", "not running"], "is &&&", "are &&&")
            let hasADescriptor = (["planned closure", "reduced service", "bus service", "change of frequency"], "has a &&&", "have a &&&")
            
            let allTheTuples = [hasDescriptor, isPartlyClosed, isClosed, specialService, isDescriptor, hasADescriptor]

            for tuple in allTheTuples {
                for serviceStatus in tuple.0 {
                    var lineCollection = [String]()
                    
                    for line in self.lineVM.allLines {
                    //for testLine in testArray {
                        
                        guard let descriptor = line.lineStatuses?.first?.statusSeverityDescription?.lowercased() else { continue }
                        guard var lineName = line.name else { continue }
                        
//                        let descriptor = testLine.1.lowercased()
//                        var lineName = testLine.0
                        
                        lineName = "\(lineName) line"
                        
                        if descriptor == "good service" {
                            continue
                        }
                        
                        if serviceStatus == descriptor {
                            lineCollection.append(lineName)
                        }
                        
                    }
                    
                    if lineCollection.isEmpty {
                        continue
                    } else if lineCollection.count == 1 {
                        speak.append("The \(lineCollection.first!) \(tuple.1.replacingOccurrences(of: "&&&", with: serviceStatus)). ")
                    } else if lineCollection.count >= 2 {
                        speak.append("The ")
                        let limit = lineCollection.count-2
                        for i in 0..<limit {
                            speak.append("\(lineCollection[i]), ")
                        }
                        speak.append("\(lineCollection[lineCollection.count-2]) and \(lineCollection.last!) \(tuple.2.replacingOccurrences(of: "&&&", with: serviceStatus)). ")
                    }
                }
            }
            
            if speak == "" {
                speak = "There is a good service on all lines."
            } else {
                speak.append("Good service on all other lines.")
            }
            
            completion(TubeStatusIntentResponse.success(statuses: "\(speak)"))
        }
    }
    
}
