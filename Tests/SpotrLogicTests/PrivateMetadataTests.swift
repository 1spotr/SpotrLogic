//
//  PrivateMetadataTests.swift
//  SpotrLogicTests
//
//  Created by Marcus on 18/11/2021.
//

import XCTest
@testable import SpotrLogic
import Combine

class PrivateMetadataTests: XCTestCase {
    
    // MARK: - Config
    
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
    
    private var cancellables : [AnyCancellable] = []
    
    // MARK: - Tests
    
    func testSelectedAreaFetch() throws {
        
        let credentials = URLCredential(user: "test@test.spotr.app",
                                        password: "Testing", persistence: .none)
        
        
        wait(for: [try login(for: logic, with: credentials)], timeout: 10)
        
        let publishedMetadataExpectation = XCTestExpectation(description: "Published metadata")
        
        
        logic.loggedUser?.$privateMetadata.sink { metadata in
            
            if let metadata = metadata {
                XCTAssertEqual(metadata.settings?.selectedAreaId, "1aab0e35-6e44-47af-826b-3ab1c0ef6107")
                
                publishedMetadataExpectation.fulfill()
            }
            
        }.store(in: &cancellables)
        
        
        wait(for: [publishedMetadataExpectation], timeout: 10)
    }
    
}
