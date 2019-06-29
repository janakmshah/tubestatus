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
            
            var speak = ""
            for line in self.lineVM.allLines {
                
                guard let descriptor = line.lineStatuses?.first?.statusSeverityDescription else { continue }
                guard let lineName = line.name else { continue }
                
                if descriptor == "Good Service" {
                    continue
                }
                
                if descriptor == "Minor Delays" || descriptor == "Severe Delays" {
                    speak.append("The \(lineName) line has \(descriptor.lowercased()). ")
                }
                
                if descriptor == "Part Closure" {
                    speak.append("The \(lineName) line is partly closed. ")
                }
                
                if descriptor == "Service Closed" {
                    speak.append("The \(lineName) line is closed. ")
                }
                
            }
            if speak == "" {
                speak = "Good service on all lines"
            } else {
                speak.append("Good service on all other lines")
            }
            
            completion(TubeStatusIntentResponse.success(statuses: "\(speak)"))
        }
    }
    
    
}
