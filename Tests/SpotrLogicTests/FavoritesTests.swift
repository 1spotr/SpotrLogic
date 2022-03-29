//
//  FavoritesTests.swift
//  SpotrLogicTests
//
//  Created by Marcus on 08/09/2021.
//

import XCTest
@testable import SpotrLogic

class FavoritesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        _ = configured
        
        logic = .init(logger: logger, protection: protectionSpace)
    }
    
    private var logic : SpotrLogic!
    
    
    override func tearDown() {
        super.tearDown()
        
        logic = nil
    }
    
    // MARK: - Favorites Tests
    
    func testAddFavorite() throws -> Void {
        let file = try file(named: "spot")
        let spot = try decoder.decode(Spot.self, from: file)
        
        wait(for: [anonymousSign(for: logic)], timeout: 10)
        let expectation = XCTestExpectation(description: "Favorite creation")
        logic.addToFavorite(spot: spot) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testAddFavoriteAsync() async throws -> Void {
        let file = try file(named: "spot")
        let spot = try decoder.decode(Spot.self, from: file)
        
        let expectation = XCTestExpectation(description: "Favorite creation")
        do {
            try await logic.addToFavorite(spot: spot)
            expectation.fulfill()
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testRemoveFavorite() throws -> Void {
        
        let file = try file(named: "spot")
        let spot = try decoder.decode(Spot.self, from: file)
        
        let expectation = XCTestExpectation(description: "Delete Favorite")
        
        logic.removeFromFavorite(spot: spot) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testRemoveFavoriteAsync() async throws -> Void {
        let file = try file(named: "spot")
        let spot = try decoder.decode(Spot.self, from: file)
        
        let expectation = XCTestExpectation(description: "Favorite creation")
        do {
            try await logic.removeFromFavorite(spot: spot)
            expectation.fulfill()
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
}
