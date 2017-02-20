//
//  SubstancesRepository.swift
//  PsychonautWiki
//
//  Created by Waldemar Barbe on 20.02.17.
//  Copyright © 2017 Waldemar Barbe. All rights reserved.
//

import Foundation
import Apollo

class SubstancesService {
    
    typealias SubstancesResultHandler = (GraphQLResult<SubstancesQuery.Data>?, Error?) -> ()
    
    static func fetchSubstances() {
        ApolloClient.shared.fetch(query: SubstancesQuery())
    }
    
    static func createWatcher(resultHandler: @escaping SubstancesResultHandler) -> GraphQLQueryWatcher<SubstancesQuery> {
        return ApolloClient.shared.watch(query: SubstancesQuery(), resultHandler: resultHandler)
    }
    
}
