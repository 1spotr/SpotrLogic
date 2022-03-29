//
//  SpotTests.swift
//  SpotTests
//
//  Created by Johann Petzold on 18/11/2021.
//

import XCTest
@testable import SpotrLogic

class SpotTests: XCTestCase {
    
    private var logic : SpotrLogic!
    
    override func setUp() {
        super.setUp()
        
        _ = configured
        
        logic = .init(logger: logger, protection: protectionSpace)
    }
    
    override func tearDown() {
        super.tearDown()
        
        logic = nil
    }
    
    func testNewSpots() throws -> Void {
        
        let file = try file(named: "area_singapore")
        
        let area = try decoder.decode(Area.self, from: file)
        
        let expectation = XCTestExpectation(description: "Spots fetching")
        
        try logic.newSpots(for: area, completion: { result in
            switch result {
            case .success(let spots):
                if let spot = spots.first {
                    XCTAssertEqual(spot.name, "17 Rue Vaugelas")
                    expectation.fulfill()
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        })
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testNewSpotsAsync() async throws -> Void {
        let file = try file(named: "area_singapore")
        let area = try decoder.decode(Area.self, from: file)
        
        let expectation = XCTestExpectation(description: "Spots fetching")
        
        do {
            let spots = try await logic.newSpots(for: area)
            if let spot = spots.first {
                XCTAssertEqual(spot.name, "17 Rue Vaugelas")
                expectation.fulfill()
            } else {
                XCTFail("No Spot")
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testPopularSpots() throws -> Void {
        
        let file = try file(named: "area_singapore")
        
        let area = try decoder.decode(Area.self, from: file)
        
        let expectation = XCTestExpectation(description: "Popular Spots fetching")
        
        try logic.popularSpots(for: area, completion: { result in
            switch result {
            case .success(let spots):
                if let spot = spots.first {
                    XCTAssertEqual(spot.name, "17 Rue Vaugelas")
                    expectation.fulfill()
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        })
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testPopularSpotsAsync() async throws -> Void {
        let file = try file(named: "area_singapore")
        let area = try decoder.decode(Area.self, from: file)
        
        let expectation = XCTestExpectation(description: "Popular Spots fetching")
        
        do {
            let spots = try await logic.popularSpots(for: area)
            if let spot = spots.first {
                XCTAssertEqual(spot.name, "17 Rue Vaugelas")
                expectation.fulfill()
            } else {
                XCTFail("No spot")
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        wait(for: [expectation], timeout: 10)
    }
}
