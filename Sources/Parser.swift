//
//  Parser.swift
//  OpenAddressesCensus
//
//  Created by David Chiles on 11/2/16.
//
//

import Foundation
import CSwiftV

enum ParserError:Error {
    case ParsingCSVData
}


class Parser {
    
    class func excludeGeoid(path:String) -> Set<String>? {
        let data = try! Data(contentsOf: NSURL(fileURLWithPath: path) as URL)
        let fileAsString = String(data:data, encoding: String.Encoding.utf8)
        if let array = fileAsString?.components(separatedBy: CharacterSet.newlines) {
             return Set(array)
        }
        return nil
    }
    
    class func allSources(path:String) -> Set<String> {
        let jsonFiles = FileManager.default.recursivePathsForResources(type: "json", path: path)
        
        
        let geoidArray = jsonFiles.map { (url) -> (String?) in
            let jsonData = try! Data(contentsOf: url)
            if let source = try! OpenAddressSource.convertJSONData(data: jsonData) {
                return source.geoid
            }
            return nil
        }.flatMap({$0})
        
        return Set(geoidArray)
    }
    
    class func censusEntries(data:Data) throws -> [CensusEntry] {
        guard let fileString = String(data:data, encoding: String.Encoding.ascii) else {
            throw ParserError.ParsingCSVData
        }
        let csv = CSwiftV(with: fileString)
        guard let keyedRows = csv.keyedRows else {
            throw ParserError.ParsingCSVData
        }
        
        return keyedRows.map { (row) -> CensusEntry? in
            return CensusEntry.parseRow(row: row)
        }.flatMap({$0})
    }
    
    class func updateCoverage(sources:Set<String>, entry:CensusEntry) -> CensusEntry {
        if sources.contains(entry.geoid) {
            return entry.updateCoverage(newCoverage: .Complete)
        }
        
        var result = entry
        sources.forEach { (sourceId) in
            result = result.updateCoverage(geoid: sourceId)
        }
        return result
    }
    
}
