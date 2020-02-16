//
//  IntentHandler.swift
//  TubeStatusIntent
//
//  Created by Janak Shah on 29/06/2019.
//  Copyright © 2019 App Ktchn. All rights reserved.
//

import Intents

class IntentHandler: INExtension {

    override func handler(for intent: INIntent) -> Any {
        guard intent is TubeStatusIntent else {
            fatalError("Unhandled intent type: \(intent)")
        }
        
        return TubeStatusIntentHandler()
    }
    
}
