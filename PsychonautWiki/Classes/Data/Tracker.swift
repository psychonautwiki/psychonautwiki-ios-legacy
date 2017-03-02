//
//  Tracker.swift
//  PsychonautWiki
//
//  Created by Waldemar Barbe on 02.03.17.
//  Copyright © 2017 Waldemar Barbe. All rights reserved.
//

import Foundation

class Tracker {
    
    enum Screens: String {
        case substancesList = "Substances List"
        
        func track() {
            guard let tracker = GAI.sharedInstance().defaultTracker else {
                Logger.logWarn("Could not get tracker.")
                return
            }
            tracker.set(kGAIScreenName, value: self.rawValue)
            
            guard let builder = GAIDictionaryBuilder.createScreenView() else {
                Logger.logWarn("Could not get builder.")
                return
            }
            tracker.send(builder.build() as [NSObject : AnyObject])
            
            Logger.logDebug("Tracked screen: \(self.rawValue)")
        }
    }
    
}
