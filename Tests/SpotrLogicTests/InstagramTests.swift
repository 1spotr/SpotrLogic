//
//  InstagramTests.swift
//  SpotrLogicTests
//
//  Created by Marcus on 03/11/2021.
//

import XCTest
@testable import SpotrLogic

class InstagramTests: XCTestCase {

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


    func testSetInstagram() throws {

        wait(for: [anonymousSign(for: logic)], timeout: 10)

        let username = "instragra_username\(Int.random(in: -100...100))_\(Int.random(in: -100...100))"

        let expectation = XCTestExpectation(description: "Instagram username creation")


        try logic.setInstagram(username: username, completion: { result in
            switch result {
                case .success:
                    break
                case .failure(let error):
                    XCTFail(error.localizedDescription)

            }
            expectation.fulfill()
        })

								waitForExpectations(timeout: 10, handler: nil)

    }
    
    func testInstagramUsernameUnavailable() {
        let username = "testing"
        
        let expectation = XCTestExpectation(description: "Check Instagram username available")
        
        logic.checkInstagramUsernameAvailable(username: username) { result in
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
    
    func testInstagramUsernameAvailable() {
        let username = "testing\(Int.random(in: 1...1000))"
        
        let expectation = XCTestExpectation(description: "Check Instagram username available")
        
        logic.checkInstagramUsernameAvailable(username: username) { result in
            switch result {
            case .success(let available):
                XCTAssertTrue(available)
                expectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [expectation], timeout: 5)
    }
}
