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
                
                guard let descriptor = line.lineStatuses?.first?.statusSeverityDescription?.lowercased() else { continue }
                guard let lineName = line.name else { continue }
                
                if descriptor == "good service" {
                    continue
                } else if descriptor == "minor delays"
                    || descriptor == "severe delays"
                    || descriptor == "no step free access"
                    || descriptor == "issues reported"
                    || descriptor == "no issues" {
                    speak.append("The \(lineName) line has \(descriptor). ")
                } else if descriptor == "part closure" || descriptor == "part closed" {
                    speak.append("The \(lineName) line is partly closed. ")
                } else if descriptor == "service closed" || descriptor == "closed" {
                    speak.append("The \(lineName) line is closed. ")
                }  else if descriptor == "special service" {
                    speak.append("The \(lineName) line is operating a special service. ")
                } else if descriptor == "suspended"
                    || descriptor == "part suspended"
                    || descriptor == "exit only"
                    || descriptor == "diverted"
                    || descriptor == "not running" {
                    speak.append("The \(lineName) line is \(descriptor). ")
                }  else if descriptor == "planned closure"
                    || descriptor == "reduced service"
                    || descriptor == "bus service"
                    || descriptor == "change of frequency" {
                    speak.append("The \(lineName) line has a \(descriptor). ")
                } else if descriptor == "information" {
                    speak.append("There is extra information available about the \(lineName) line. ")
                }
                
            }
            if speak == "" {
                speak = "There is a good service on all lines"
            } else {
                speak.append("Good service on all other lines")
            }
            
            completion(TubeStatusIntentResponse.success(statuses: "\(speak)"))
        }
    }
    
    
}
