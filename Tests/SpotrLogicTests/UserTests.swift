//
//  UserTests.swift
//  SpotrLogicTests
//
//  Created by Johann Petzold on 06/12/2021.
//

import XCTest
@testable import SpotrLogic

class UserTests: XCTestCase {
    
    // MARK: - Config

    override func setUp() {
        super.setUp()

        _ = configured

        logic = .init(logger: logger)
    }

    private var logic : SpotrLogic!


    override func tearDown() {
        super.tearDown()

        logic = nil
    }
    
    // MARK: - Tests
    
    func testUsernameAvailable() {
        let username = "test"
        
        let expectation = XCTestExpectation(description: "Check username available")
        
        logic.checkUsernameAvailable(username: username) { result in
            switch result {
            case .success(let available):
                XCTAssertFalse(available)
                expectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [expectation], timeout: 5)
    }
}
