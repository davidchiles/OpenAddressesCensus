

struct CensusEntry {
	let geoid:String
	let name:String
	let population:Int
    let coverage:Coverage
    
    func updateCoverage(newCoverage:Coverage) -> CensusEntry {
        if (self.coverage.rawValue < newCoverage.rawValue) {
            return CensusEntry(geoid: self.geoid, name: self.name, population: self.population, coverage: newCoverage)
        }
        return self
    }
    
    func updateCoverage(geoid:String) -> CensusEntry {
        return self.updateCoverage(newCoverage:Coverage.geoidCoverage(first: self.geoid, second: geoid))
    }
}

enum Coverage:Int {
    case None
    case State
    case Complete
    
    var description:String {
        switch self {
        case .None:
            return "None"
        case .State:
            return "State"
        case .Complete:
            return "Complete"
        }
    }
    
    static let allValues = [Complete, State, None]

    /** Results in how the second covers the first */
    static func geoidCoverage(first:String,second:String) -> Coverage {
        if first == second {
            return .Complete
        } else if first.characters.count > second.characters.count && first.substring(to: first.index(first.startIndex, offsetBy: 2)) == second.substring(to:  second.index(second.startIndex, offsetBy: 2)){
            return .State
        }
        return .None
    }
}

extension CensusEntry {
    static func parseRow(row: [String:String]) -> CensusEntry? {
        guard let name = row["GEO.display-label"], let geoid = row["GEO.id2"], let populationString = row["respop72015"] else {
            return nil
        }
        
        guard let population = Int(populationString) else {
            return nil
        }
        
        return CensusEntry(geoid: geoid, name: name, population: population, coverage:.None)
    }
}


