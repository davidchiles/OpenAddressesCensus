import XCTest
@testable import OpenAddressesCensus


class CensusEntryTests: XCTestCase {

	func testCoverage() {
		XCTAssertEqual(Coverage.geoidCoverage(first: "11223", second: "11223"),Coverage.Complete)
        XCTAssertEqual(Coverage.geoidCoverage(first: "11", second: "12555"),Coverage.None)
        XCTAssertEqual(Coverage.geoidCoverage(first: "11555", second: "11"),Coverage.State)
	}
    
    func testCensusCoverage() {
        var entry = CensusEntry(geoid: "12345", name: "", population: 100, coverage: .None)
        XCTAssertEqual(entry.updateCoverage(geoid:"12").coverage,Coverage.State)
        XCTAssertEqual(entry.updateCoverage(geoid:"12345").coverage,Coverage.Complete)
        
        entry = CensusEntry(geoid: "12345", name: "", population: 100, coverage: .Complete)
        XCTAssertEqual(entry.updateCoverage(geoid:"12").coverage,Coverage.Complete)
        XCTAssertEqual(entry.updateCoverage(geoid:"1234545").coverage,Coverage.Complete)
        XCTAssertEqual(entry.updateCoverage(geoid:"12345").coverage,Coverage.Complete)
        
        entry = CensusEntry(geoid: "12345", name: "", population: 100, coverage: .State)
        XCTAssertEqual(entry.updateCoverage(geoid:"12").coverage,Coverage.State)
        XCTAssertEqual(entry.updateCoverage(geoid:"1234545").coverage,Coverage.State)
        XCTAssertEqual(entry.updateCoverage(geoid:"12345").coverage,Coverage.Complete)
        
        XCTAssertEqual(entry.updateCoverage(geoid:"12").coverage,Coverage.State)
        XCTAssertEqual(entry.updateCoverage(geoid:"12345").coverage,Coverage.Complete)
    }
}
