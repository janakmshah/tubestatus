//
//  ReminderVM.swift
//  TubeStatus
//
//  Created by Janak Shah on 10/07/2019.
//  Copyright © 2019 App Ktchn. All rights reserved.
//

import Foundation
import TubeStatusCore

enum DayOfWeek: String, CaseIterable {
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    case Sunday
}

struct ReminderVM {
    var days: [DayOfWeek]
    var time: String
    var lines: [LineID]
    var id: String
}
