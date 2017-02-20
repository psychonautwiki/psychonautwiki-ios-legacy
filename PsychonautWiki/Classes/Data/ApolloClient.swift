//
//  ApolloClient.swift
//  PsychonautWiki
//
//  Created by Waldemar Barbe on 20.02.17.
//  Copyright © 2017 Waldemar Barbe. All rights reserved.
//

import Foundation
import Apollo

class ApolloClient {
    static let shared = Apollo.ApolloClient(url: URL(string: "https://api.psychonautwiki.org/")!)
}
