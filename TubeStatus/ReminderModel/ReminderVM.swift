//
//  ReminderVM.swift
//  TubeStatus
//
//  Created by Janak Shah on 10/07/2019.
//  Copyright © 2019 App Ktchn. All rights reserved.
//

import Foundation
import TubeStatusCore

enum DayOfWeek: String {
    case Mon
    case Tue
    case Wed
    case Thu
    case Fri
    case Sat
    case Sun
}

class ReminderVM {
    let days: [DayOfWeek]
    let time: String
    let lines: [LineID]
    
    init(days: [DayOfWeek], time: String, lines: [LineID]) {
        self.days = days
        self.time = time
        self.lines = lines
    }
}
