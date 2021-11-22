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

        waitForAnonymousSign()

        let username = "instragra_username\(Int.random(in: -100...100))_\(Int.random(in: -100...100))"

        let expectation = XCTestExpectation(description: "Residence creation")


        try logic.setInstagram(username: username, completion: { result in
            switch result {
                case .success:
                    break
                case .failure(let error):
                    XCTFail(error.localizedDescription)

            }
            expectation.fulfill()
        })

    }


    func waitForAnonymousSign() -> Void {
        let expectation = XCTestExpectation(description: "Anonymous sign")
        logic.loginAnonymously { result in
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

}
