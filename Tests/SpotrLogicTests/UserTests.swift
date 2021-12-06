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
    
    func testSendEmailVerification() throws {
        let loginCredentials = URLCredential(user: "test@test.spotr.app", password: "Testing", persistence: .none)
        
        let expectation = XCTestExpectation(description: "Wait for sending email verification")
        
        try logic.login(with: loginCredentials, completion: { result in
            switch result {
            case .success:
                self.logic.sendEmailVerification { error in
                    if let error = error {
                        XCTFail(error.localizedDescription)
                    } else {
                        expectation.fulfill()
                    }
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        })
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testUpdateUserEmail() throws {
        let password = "Testing"
        let newEmail = "usertest2@test.spotr.app"
        let loginCredentials = URLCredential(user: "usertest@test.spotr.app", password: "Testing", persistence: .none)
        
        let expectation = XCTestExpectation(description: "Waiting for update user email")
        
        try logic.login(with: loginCredentials, completion: { result in
            switch result {
            case .success:
                self.logic.updateUserEmail(password: password, newEmail: newEmail) { error in
                    if let error = error {
                        XCTFail(error.localizedDescription)
                    } else {
                        expectation.fulfill()
                    }
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        })
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testUpdateUserPassword() throws {
        let newPassword = "Testing1"
        let actualPassword = "Testing"
        let loginCredentials = URLCredential(user: "passwordtest@test.spotr.app", password: actualPassword, persistence: .none)
        
        let expectation = XCTestExpectation(description: "Waiting for update user password")
        
        try logic.login(with: loginCredentials, completion: { result in
            switch result {
            case .success:
                self.logic.updateUserPassword(password: actualPassword, newPassword: newPassword) { error in
                    if let error = error {
                        XCTFail(error.localizedDescription)
                    } else {
                        expectation.fulfill()
                    }
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        })
        
        wait(for: [expectation], timeout: 5)
    }
}
