//
//  Result.swift
//  OpenAddressesCensus
//
//  Created by David Chiles on 11/18/16.
//
//

import Foundation

struct Result {
    
    let entries:[CensusEntry]
    
    func filter(coverage:Coverage?) -> [CensusEntry] {
        return self.entries.filter { (entry) -> Bool in
            if coverage == nil {
                return true
            }
            return entry.coverage == coverage
        }
    }
    
    func population(coverage:Coverage?) -> Int {
        return self.filter(coverage: coverage).reduce(0, { (start, entry) in
            return start + entry.population
        })
    }
}
