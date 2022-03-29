//
//  TagTests.swift
//  TagTests
//
//  Created by Johann Petzold on 18/11/2021.
//

import XCTest
@testable import SpotrLogic

class TagTests: XCTestCase {
    
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
    
    func testTags() throws -> Void {
        let file = try file(named: "area_singapore")
        let area = try decoder.decode(Area.self, from: file)
        
        let expectation = XCTestExpectation(description: "TagGrid fetching")
        
        try logic.tags(for: area) { result in
            switch result {
            case .success(let tags):
                XCTAssertEqual(tags.first?.name, "architecture")
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testTagsAsync() async throws -> Void {
        let file = try file(named: "area_singapore")
        let area = try decoder.decode(Area.self, from: file)
        
        let expectation = XCTestExpectation(description: "TagGrid fetching")
        
        do {
            let tags = try await logic.tags(for: area)
            XCTAssertEqual(tags.first?.name, "architecture")
            expectation.fulfill()
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testTag() -> Void {
        let id: Tag.ID = "028ec488-c955-4212-8981-7ed1ce7665c4"
        
        let expectation = XCTestExpectation(description: "Tag fetching")
        
        logic.tag(for: id, completion: { result in
            switch result {
            case .success(let tag):
                XCTAssertEqual(tag.name, "metal")
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testTagAsync() async -> Void {
        let id: Tag.ID = "028ec488-c955-4212-8981-7ed1ce7665c4"
        
        let expectation = XCTestExpectation(description: "Tag fetching")
        
        do {
            let tag = try await logic.tag(for: id)
            XCTAssertEqual(tag.name, "metal")
            expectation.fulfill()
        } catch {
            XCTFail(error.localizedDescription)
        }

        wait(for: [expectation], timeout: 10)
    }
}
