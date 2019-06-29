//
//  AuctionModel.swift
//  FCAuctions
//
//  Created by Janak Shah on 18/06/2019.
//  Copyright © 2019 App Ktchn. All rights reserved.
//

import Foundation

enum LineID : String, Codable {
    case bakerloo
    case central
    case circle
    case district
    case hammersmithCity = "hammersmith-city"
    case jubilee
    case metropolitan
    case northern
    case piccadilly
    case victoria
    case waterlooCity = "waterloo-city"
    case londonOverground = "london-overground"
    case dlr
}

struct LineStatus: Codable {
    let statusSeverityDescription: String?
    let reason: String?
    
    var prettyReason: String? {
        guard let reason = reason else { return nil }
        if let range: Range<String.Index> = reason.range(of: ": ") {
            let index: Int = reason.distance(from: range.upperBound, to: reason.endIndex)
            return String(reason.suffix(index))
        }
        return reason
    }
}

struct Line: Codable {
    let id: LineID
    let name: String?
    let lineStatuses: [LineStatus]?
    var mainColour : UIColor {
        switch id {
        case .bakerloo:
            return UIColor(red:0.70, green:0.39, blue:0.02, alpha:1.0)
        case .central:
            return UIColor(red:0.89, green:0.13, blue:0.09, alpha:1.0)
        case .circle:
            return UIColor(red:1.00, green:0.83, blue:0.00, alpha:1.0)
        case .district:
            return UIColor(red:0.00, green:0.47, blue:0.16, alpha:1.0)
        case .hammersmithCity:
            return UIColor(red:0.95, green:0.66, blue:0.73, alpha:1.0)
        case .jubilee:
            return UIColor(red:0.63, green:0.65, blue:0.66, alpha:1.0)
        case .metropolitan:
            return UIColor(red:0.61, green:0.00, blue:0.34, alpha:1.0)
        case .northern:
            return UIColor(red:0.06, green:0.06, blue:0.06, alpha:1.0)
        case .piccadilly:
            return UIColor(red:0.00, green:0.21, blue:0.53, alpha:1.0)
        case .victoria:
            return UIColor(red:0.00, green:0.60, blue:0.83, alpha:1.0)
        case .waterlooCity:
            return UIColor(red:0.58, green:0.80, blue:0.73, alpha:1.0)
        case .londonOverground:
            return UIColor(red:0.93, green:0.49, blue:0.05, alpha:1.0)
        case .dlr:
            return UIColor(red:0.00, green:0.64, blue:0.65, alpha:1.0)
        }
    }
    var textColour : UIColor {
        switch id {
        case .bakerloo:
            return .primaryBGColour
        case .central:
            return .primaryBGColour
        case .circle:
            return .secondaryColour
        case .district:
            return .primaryBGColour
        case .hammersmithCity:
            return .secondaryColour
        case .jubilee:
            return .secondaryColour
        case .metropolitan:
            return .primaryBGColour
        case .northern:
            return .primaryBGColour
        case .piccadilly:
            return .primaryBGColour
        case .victoria:
            return .primaryBGColour
        case .waterlooCity:
            return .secondaryColour
        case .londonOverground:
            return .primaryBGColour
        case .dlr:
            return .primaryBGColour
        }
    }
}
