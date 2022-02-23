//
//  AuthenticationsTests.swift
//  SpotrLogicTests
//
//  Created by Marcus on 16/08/2021.
//

import XCTest
@testable import SpotrLogic

class AuthenticationsTests: XCTestCase {

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

    // MARK: - Sign Tests

    /// Test user account creation
    func testUserCreation() throws {

        let newUserCredentials = URLCredential(user: "spotr-logic-\(Int.random(in: 0...10_000))@test.spotr.app", password: "Testing", persistence: .none)

        let expectation = XCTestExpectation(description: "User creation")

        try logic.sign(with: newUserCredentials) { result in

            switch result {
                case .success:
                    break
                case .failure(let error):
                    XCTFail(error.localizedDescription)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 3)

        let loginExpectation = XCTestExpectation(description: "login")

        try logic.login(with: newUserCredentials) { result in

            switch result {
                case .success:
                    break
                case .failure(let error):
                    XCTFail(error.localizedDescription)
            }

            loginExpectation.fulfill()
        }

        wait(for: [loginExpectation], timeout: 3)

    }


    // MARK: - Login

    func testloginAnonymousLogin() {

        let expectation = XCTestExpectation(description: "User login")

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

    /// Test user login.
    func testLogin() throws {
        let loginCredentials = URLCredential(user: "test@test.spotr.app", password: "Testing", persistence: .none)

        let expectation = XCTestExpectation(description: "User login")

        try logic.login(with: loginCredentials) { result in

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
