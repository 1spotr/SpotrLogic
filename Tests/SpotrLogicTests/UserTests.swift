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
    
    func testUsernameUnavailable() {
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
    
    func testUsernameAvailable() {
        let username = "test\(Int.random(in: 1...100))"
        
        let expectation = XCTestExpectation(description: "Check username available")
        
        logic.checkUsernameAvailable(username: username) { result in
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
    
    // MARK: Send Email Verification
    
    func testSendEmailVerification() throws {
        let loginCredentials = URLCredential(user: "test@test.spotr.app", password: "Testing", persistence: .none)
        
        let expectation = XCTestExpectation(description: "Wait for sending email verification")
        
        wait(for: [try login(for: logic, with: loginCredentials)], timeout: 10)
        
        logic.sendEmailVerification { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    // MARK: Send Password Reset Email
    
    func testSendPasswordResetEmail() {
        let email = "test@test.spotr.app"
        
        let expectation = XCTestExpectation(description: "Wait for sending password reset email")
        
        logic.sendPasswordResetEmail(email: email) { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testSendPasswordResetBadEmail() {
        let email = "noemail@noemail.com"
        
        let expectation = XCTestExpectation(description: "Wait for sending password reset email")
        
        logic.sendPasswordResetEmail(email: email) { result in
            switch result {
            case .success:
                break
            case .failure:
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    // MARK: Update User Email
    
    func testUpdateUserEmail() throws {
        let password = "Testing"
        let newEmail = "usertest2@test.spotr.app"
        let loginCredentials = URLCredential(user: "usertest@test.spotr.app", password: "Testing", persistence: .none)
        
        let expectation = XCTestExpectation(description: "Waiting for update user email")
        
        wait(for: [try login(for: logic, with: loginCredentials)], timeout: 10)
        
        try logic.updateUserEmail(password: password, newEmail: newEmail) { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testUpdateUserEmailWithNoUser() {
        
        let expectation = XCTestExpectation(description: "Waiting for update user email")
        
        do {
            try logic.updateUserEmail(password: "", newEmail: "", completion: { result in
                switch result {
                case .success:
                    break
                case .failure:
                    break
                }
            })
        } catch {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testUpdateUserEmailWithBadPassword() throws {
        let password = "Testin"
        let newEmail = "usererrortest2@test.spotr.app"
        let loginCredentials = URLCredential(user: "usererrortest@test.spotr.app", password: "Testing", persistence: .none)
        
        let expectation = XCTestExpectation(description: "Waiting for update user email")
        
        wait(for: [try login(for: logic, with: loginCredentials)], timeout: 10)
        
        try logic.updateUserEmail(password: password, newEmail: newEmail, completion: { result in
            switch result {
            case .success:
                break
            case .failure:
                expectation.fulfill()
            }
        })
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testUpdateUserEmailWithSameEmail() throws {
        let password = "Testing"
        let newEmail = "test@test.spotr.app"
        let loginCredentials = URLCredential(user: "usererrortest@test.spotr.app", password: "Testing", persistence: .none)
        
        let expectation = XCTestExpectation(description: "Waiting for update user email")
        
        wait(for: [try login(for: logic, with: loginCredentials)], timeout: 10)
        
        try logic.updateUserEmail(password: password, newEmail: newEmail, completion: { result in
            switch result {
            case .success:
                break
            case .failure:
                expectation.fulfill()
            }
        })
        
        wait(for: [expectation], timeout: 5)
    }
    
    // MARK: Update User Password
    
    func testUpdateUserPassword() throws {
        let newPassword = "Testing1"
        let actualPassword = "Testing"
        let loginCredentials = URLCredential(user: "passwordtest@test.spotr.app", password: actualPassword, persistence: .none)
        
        let expectation = XCTestExpectation(description: "Waiting for update user password")
        
        wait(for: [try login(for: logic, with: loginCredentials)], timeout: 10)
        
        try logic.updateUserPassword(password: actualPassword, newPassword: newPassword) { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testUpdateUserPasswordWithNoUser() {
        
        let expectation = XCTestExpectation(description: "Waiting for update user email")
        
        do {
            try logic.updateUserPassword(password: "", newPassword: "", completion: { result in
                switch result {
                case .success:
                    break
                case .failure:
                    break
                }
            })
        } catch {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testUpdateUserPasswordWithBadPassword() throws {
        let password = "Testin"
        let loginCredentials = URLCredential(user: "usererrortest@test.spotr.app", password: "Testing", persistence: .none)
        
        let expectation = XCTestExpectation(description: "Waiting for update user email")
        
        wait(for: [try login(for: logic, with: loginCredentials)], timeout: 10)
        
        try logic.updateUserPassword(password: password, newPassword: "", completion: { result in
            switch result {
            case .success:
                break
            case .failure:
                expectation.fulfill()
            }
        })
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testUpdateUserPasswordWithWeakNewPassword() throws {
        let password = "Testing"
        let newPassword = "123"
        let loginCredentials = URLCredential(user: "usererrortest@test.spotr.app", password: "Testing", persistence: .none)
        
        let expectation = XCTestExpectation(description: "Waiting for update user email")
        
        wait(for: [try login(for: logic, with: loginCredentials)], timeout: 10)
        
        try logic.updateUserPassword(password: password, newPassword: newPassword, completion: { result in
            switch result {
            case .success:
                break
            case .failure:
                expectation.fulfill()
            }
        })
        
        wait(for: [expectation], timeout: 5)
    }
    
    // MARK: Set Username
    func testSetUsername() throws {

        wait(for: [anonymousSign(for: logic)], timeout: 10)

        let username = "username\(Int.random(in: -100...100))_\(Int.random(in: -100...100))"

        let expectation = XCTestExpectation(description: "Username creation")


        try logic.setUsername(username: username, completion: { result in
            switch result {
                case .success:
                expectation.fulfill()
                break
                case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        })
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testSetUsernameNotAuth() {

        let expectation = XCTestExpectation(description: "Username creation")

        do {
            try logic.setUsername(username: "test", completion: { result in
            switch result {
                case .success:
                break
                case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        })
        } catch {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
}
