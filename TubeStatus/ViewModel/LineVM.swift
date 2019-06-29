//
//  AuctionListVM.swift
//  FCAuctions
//
//  Created by Janak Shah on 20/06/2019.
//  Copyright © 2019 App Ktchn. All rights reserved.
//

import Foundation

protocol Refreshable {
    func refresh()
}

class LineVM {
    private var allLines = [Line]()
    var standardLines = [Line]()
    var favouriteLines = [Line]()
    var lastUpdated = NSDate()
    
    var favourites: Set<String> {
        let defaults = UserDefaults.standard
        return Set<String>(defaults.object(forKey: "favourites") as? Array<String> ?? Array<String>())
    }
    
    var prettyLastUpdated: String? {
        if let timeRemaining = format(timeInterval: -lastUpdated.timeIntervalSinceNow) {
            return "Updated \(timeRemaining)"
        } else {
            return nil
        }
    }
    
    func format(timeInterval: TimeInterval) -> String? {
        
        if timeInterval == 0 {
            return nil
        }
        
        var days = 0, hours = 0, minutes = 0, seconds = 0
        splitInterval(interval: Int(timeInterval), days: &days, hours: &hours, minutes: &minutes, seconds: &seconds)
        
        if days > 0 {
            return "\(days) \(days == 1 ? "day" : "days") ago - Pull to refresh"
        }
        if hours > 0 {
            return "\(hours) \(hours == 1 ? "hour" : "hours") ago - Pull to refresh"
        }
        if minutes > 0 {
            return "\(minutes) \(minutes == 1 ? "min" : "mins") ago"
        }
        if seconds > 44 {
            return "45 seconds ago"
        }
        if seconds > 29 {
            return "30 seconds ago"
        }
        if seconds > 9 {
            return "10 seconds ago"
        }
        return "just now"
    }
    
    private func splitInterval(interval: Int, days:inout Int, hours:inout Int, minutes:inout Int, seconds: inout Int) {
        var newInterval = interval
        days = newInterval / 86400
        newInterval %= 86400
        hours = newInterval / 3600
        newInterval %= 3600
        minutes = newInterval / 60
        seconds = newInterval % 60
    }
    
    func loadAuctions(from parent: UIViewController & Refreshable) {
        MBProgressHUD.showAdded(to: parent.view, animated: true)
        Service.shared.fetchAuctions { [weak parent, weak self] (serverResponse, error) in

            guard let parent = parent else {return}
            guard let self = self else {return}
            MBProgressHUD.hide(for: parent.view, animated: true)
            if let error = error {
                self.showError(error, on: parent)
            }
            guard let serverResponse = serverResponse else { return }
            self.lastUpdated = NSDate()
            self.allLines = serverResponse.sorted(by: {
                $0.lineStatuses?.first?.reason ?? "" > $1.lineStatuses?.first?.reason ?? ""
            })
            
            self.separateFaves()
            parent.refresh()
        }
    }
    
    func separateFaves() {
        self.standardLines = []
        self.favouriteLines = []
        
        self.standardLines = allLines.filter({ !self.favourites.contains($0.id.rawValue)
        })
        self.favouriteLines = allLines.filter({ self.favourites.contains($0.id.rawValue)
        })
    }

    func addToFaves(lineID: LineID) {
        let defaults = UserDefaults.standard
        var tempFaves = favourites
        tempFaves.insert(lineID.rawValue)
        defaults.set(Array(tempFaves), forKey: "favourites")
    }
    
    func removeFromFaves(lineID: LineID) {
        let defaults = UserDefaults.standard
        var tempFaves = favourites
        tempFaves.remove(lineID.rawValue)
        defaults.set(Array(tempFaves), forKey: "favourites")
    }
    
    func showError(_ error: Error, on parent: UIViewController) {
        let alert = UIAlertController(title: "Something went wrong 🤔",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        alert.addAction(cancel)
        parent.present(alert, animated: true, completion: nil)
    }

}
