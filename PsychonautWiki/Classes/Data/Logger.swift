//
//  Logger.swift
//  PsychonautWiki
//
//  Created by Waldemar Barbe on 02.03.17.
//  Copyright © 2017 Waldemar Barbe. All rights reserved.
//

import Foundation

class Logger {
    
    static func logWarn(_ message: String) {
        print("!! ==== \(message)")
    }
    
    static func logDebug(_ message: String) {
        print("? ==== \(message)")
    }
    
}
