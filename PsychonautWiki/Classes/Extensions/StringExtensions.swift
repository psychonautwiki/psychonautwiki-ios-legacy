//
//  StringExtensions.swift
//  PsychonautWiki
//
//  Created by Waldemar Barbe on 27.03.17.
//  Copyright © 2017 Waldemar Barbe. All rights reserved.
//

import Foundation

extension String {
    
    func containsFuzzy(_ string: String) -> Bool {
        let originalString = self.lowercased().replacingAllMatching("\\s", with: "")
        let stringToSearch = string.lowercased().replacingAllMatching("\\s", with: "")
        
        if originalString.characters.count == 0 || stringToSearch.characters.count == 0 {
            return false
        }
        
        if originalString.characters.count < stringToSearch.characters.count {
            return false
        }
        
        var searchIndex : Int = 0
        for charOut in originalString.characters {
            for (indexIn, charIn) in stringToSearch.characters.enumerated() {
                if indexIn == searchIndex {
                    if charOut == charIn {
                        searchIndex += 1
                        if searchIndex == stringToSearch.characters.count {
                            return true
                        } else {
                            break
                        }
                    } else {
                        break
                    }
                }
            }
        }
        return false
    }
    
}
