//
//  Formatter.swift
//  OpenAddressesCensus
//
//  Created by David Chiles on 11/18/16.
//
//

import Foundation

protocol ResultFormatter {
    func format(result:Result) -> String
}


struct MarkdownResultFormatter : ResultFormatter {
    
    
    func format(result: Result) -> String {
        
        var stringResult = "| | Population | Population % |\n| --- | --- | --- |"
        
        let totalPopulation = result.population(coverage: nil)
        
        for coverage in Coverage.allValues {
            let population = result.population(coverage: coverage)
            let percent = String(format: "%.1f", Double(population)/Double(totalPopulation)*100.0)
            stringResult += "\n| \(coverage) | \(population) | \(percent)% |"
        }
        
        
        let sorted = result.filter(coverage: Coverage.None).sorted(by: { (entry1, entry2) -> Bool in
            return entry1.population > entry2.population
        })
        stringResult += "\n\n| Name | Population | GEOID |\n| --- | --- | --- |"
        
        for entry in sorted {
            stringResult += "\n| \(entry.name) | \(entry.population) | \(entry.geoid) |"
        }
        
        
        return stringResult
    }
}
