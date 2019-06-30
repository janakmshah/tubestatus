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
            var minorDelays = [String]()
            var severeDelays = [String]()
            var noStepFreeAccess = [String]()
            var issuesReported = [String]()
            var noIssues = [String]()
            var partClosure = [String]()
            var serviceClosed = [String]()
            var specialService = [String]()
            var suspended = [String]()
            var partSuspended = [String]()
            var exitOnly = [String]()
            var diverted = [String]()
            var notRunning = [String]()
            var plannedClosure = [String]()
            var reducedService = [String]()
            var busService = [String]()
            var changeOfFrequency = [String]()
            var information = [String]()

            for line in self.lineVM.allLines {
                
                guard let descriptor = line.lineStatuses?.first?.statusSeverityDescription?.lowercased() else { continue }
                guard var lineName = line.name else { continue }
                lineName = "\(lineName) line"
                
                if descriptor == "minor delays" {
                    minorDelays.append(lineName)
                } else if descriptor == "severe delays" {
                    severeDelays.append(lineName)
                } else if descriptor == "severe delays" {
                    noStepFreeAccess.append(lineName)
                } else if descriptor == "severe delays" {
                    issuesReported.append(lineName)
                } else if descriptor == "severe delays" {
                    noIssues.append(lineName)
                } else if descriptor == "severe delays" {
                    partClosure.append(lineName)
                } else if descriptor == "severe delays" {
                    serviceClosed.append(lineName)
                } else if descriptor == "severe delays" {
                    specialService.append(lineName)
                } else if descriptor == "severe delays" {
                    suspended.append(lineName)
                } else if descriptor == "severe delays" {
                    partSuspended.append(lineName)
                } else if descriptor == "severe delays" {
                    exitOnly.append(lineName)
                } else if descriptor == "severe delays" {
                    diverted.append(lineName)
                } else if descriptor == "severe delays" {
                    notRunning.append(lineName)
                } else if descriptor == "severe delays" {
                    plannedClosure.append(lineName)
                } else if descriptor == "severe delays" {
                    reducedService.append(lineName)
                } else if descriptor == "severe delays" {
                    busService.append(lineName)
                } else if descriptor == "severe delays" {
                    changeOfFrequency.append(lineName)
                } else if descriptor == "severe delays" {
                    information.append(lineName)
                }
                
                if descriptor == "good service" {
                    continue
                } else if descriptor == "minor delays"
                    || descriptor == "severe delays"
                    || descriptor == "no step free access"
                    || descriptor == "issues reported"
                    || descriptor == "no issues" {
                    speak.append("The \(lineName) has \(descriptor). ")
                } else if descriptor == "part closure" || descriptor == "part closed" {
                    speak.append("The \(lineName) is partly closed. ")
                } else if descriptor == "service closed" || descriptor == "closed" {
                    speak.append("The \(lineName) is closed. ")
                }  else if descriptor == "special service" {
                    speak.append("The \(lineName) is operating a special service. ")
                } else if descriptor == "suspended"
                    || descriptor == "part suspended"
                    || descriptor == "exit only"
                    || descriptor == "diverted"
                    || descriptor == "not running" {
                    speak.append("The \(lineName) is \(descriptor). ")
                }  else if descriptor == "planned closure"
                    || descriptor == "reduced service"
                    || descriptor == "bus service"
                    || descriptor == "change of frequency" {
                    speak.append("The \(lineName) has a \(descriptor). ")
                } else if descriptor == "information" {
                    speak.append("There is extra information available about the \(lineName). ")
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
