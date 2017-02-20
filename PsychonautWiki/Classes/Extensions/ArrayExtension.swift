//
//  ArrayExtensions.swift
//  PsychonautWiki
//
//  Created by Waldemar Barbe on 20.02.17.
//  Copyright © 2017 Waldemar Barbe. All rights reserved.
//

import Foundation

extension Array {
    func element(atIndex index: Int) -> Element? {
        guard self.indices.contains(index) else { return nil }
        return self[index]
    }
}
