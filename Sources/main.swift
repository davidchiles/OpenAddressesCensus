import CSwiftV
import Foundation

let  coverage:(Set<String>,String) -> Coverage = { set, geoid in
    var result = Coverage.None
    if set.contains(geoid) {
        result = .Complete
    } else {
        for id in set {
            result = Coverage.geoidCoverage(first: geoid, second: id)
            if result == .State {
                break
            }
        }
    }
    
    return result
}

if (CommandLine.arguments.count > 2) {
    let csvPath = CommandLine.arguments[1]
    let openAddressPath = CommandLine.arguments[2]
    
    var allCounties = [String:CensusEntry]()
    
    var sources = Parser.allSources(path: openAddressPath)
    let csvData = try! Data(contentsOf: URL(fileURLWithPath: csvPath))
    let censusEntries = try! Parser.censusEntries(data: csvData)
    
    if (CommandLine.arguments.count > 3) {
        let excludePath = CommandLine.arguments[3]
        if let excludeSet = Parser.excludeGeoid(path: excludePath) {
            sources = sources.union(excludeSet)
        }
    }
    
    
    let allEntries = censusEntries.map({ (entry) -> CensusEntry in
        return Parser.updateCoverage(sources: sources, entry: entry)
    })
    
    let result = Result(entries: allEntries)
    
    let formatedResult = MarkdownResultFormatter().format(result: result)
    print("\(formatedResult)")
//    
//    let sorted = results.filter(filterBlockGenerator(.None)).sorted(by: { (entry1, entry2) -> Bool in
//        return entry1.population > entry2.population
//    })
//    
//    sorted[0...50].forEach({ (entry) in
//        print("\(entry.population) \(entry.name) \(entry.geoid)")
//    })
} else {
    print("Needs arguments")
}
