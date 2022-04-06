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
    
    private var logic : SpotrLogic!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        _ = configured
        logic = .init(logger: logger, protection: protectionSpace)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        try logic.logout()
        logic = nil
    }
    
    // MARK: - Tests
    
    func testUsernameUnavailable() {
        let username = "test"
        
        let expectation = XCTestExpectation(description: "Check username available")
        
        wait(for: [anonymousSign(for: logic)], timeout: 5)
        
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
    
    func testUsernameUnavailableAsync() async {
        let username = "test"
        
        let expectation = XCTestExpectation(description: "Check username available")
        
        wait(for: [anonymousSign(for: logic)], timeout: 5)
        
        do {
            let available = try await logic.checkUsernameAvailable(username: username)
            XCTAssertFalse(available)
            expectation.fulfill()
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testUsernameAvailable() {
        let username = "test\(Int.random(in: 1...100))"
        
        let expectation = XCTestExpectation(description: "Check username available")
        
        wait(for: [anonymousSign(for: logic)], timeout: 5)
        
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
    
    func testUsernameAvailableAsync() async {
        let username = "test\(Int.random(in: 1...100))"
        
        let expectation = XCTestExpectation(description: "Check username available")
        
        wait(for: [anonymousSign(for: logic)], timeout: 5)
        
        do {
            let available = try await logic.checkUsernameAvailable(username: username)
            XCTAssertTrue(available)
            expectation.fulfill()
        } catch {
            XCTFail(error.localizedDescription)
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
    
    func testSendEmailVerificationAsync() async throws {
        let loginCredentials = URLCredential(user: "test@test.spotr.app", password: "Testing", persistence: .none)
        
        let expectation = XCTestExpectation(description: "Wait for sending email verification")
        
        wait(for: [try login(for: logic, with: loginCredentials)], timeout: 10)
        
        do {
            try await logic.sendEmailVerification()
            expectation.fulfill()
        } catch {
            XCTFail(error.localizedDescription)
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
    
    func testSendPasswordResetEmailAsync() async {
        let email = "test@test.spotr.app"
        
        let expectation = XCTestExpectation(description: "Wait for sending password reset email")
        
        do {
            try await logic.sendPasswordResetEmail(email: email)
            expectation.fulfill()
        } catch {
            XCTFail(error.localizedDescription)
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
    
    func testSendPasswordResetBadEmailAsync() async {
        let email = "noemail@noemail.com"
        
        let expectation = XCTestExpectation(description: "Wait for sending password reset email")
        
        do {
            try await logic.sendPasswordResetEmail(email: email)
            XCTFail("Bad Email")
        } catch {
            expectation.fulfill()
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
        
        try? logic.logout()
        
        let expectation = XCTestExpectation(description: "Waiting for update user email")
        
        do {
            try logic.updateUserEmail(password: "", newEmail: "", completion: { result in
                XCTFail("Completion result must not be called")
                expectation.fulfill()
            })
        } catch {
            XCTAssertEqual(error as! SpotrLogic.UserErrors, .noCurrentUser)
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
        
        try? logic.logout()
        
        let expectation = XCTestExpectation(description: "Waiting for update user email")
        
        do {
            try logic.updateUserPassword(password: "", newPassword: "", completion: { result in
                XCTFail("Completion result must not be called")
                expectation.fulfill()
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
    func testSetUsername() {
        
        wait(for: [anonymousSign(for: logic)], timeout: 10)
        
        let username = "username\(Int.random(in: -100...100))_\(Int.random(in: -100...100))"
        
        let expectation = XCTestExpectation(description: "Username creation")
        
        
        logic.setUsername(username: username, completion: { result in
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
    
    func testSetUsernameAsync() async {
        
        wait(for: [anonymousSign(for: logic)], timeout: 10)
        
        let username = "username\(Int.random(in: -100...100))_\(Int.random(in: -100...100))"
        
        let expectation = XCTestExpectation(description: "Username creation")
        
        do {
            try await logic.setUsername(username: username)
            expectation.fulfill()
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testSetUsernameNotAuth() {
        
        try? logic.logout()
        
        let expectation = XCTestExpectation(description: "Username creation")
        
        logic.setUsername(username: "test", completion: { result in
            switch result {
            case .success:
                XCTFail("No auth")
            case .failure(_):
                expectation.fulfill()
            }
        })
        
        wait(for: [expectation], timeout: 5)
    }
    
    // MARK: Get User Public Metadata
    func testGetUserPublicData() async {
        let id = "peSMGms0yCi1tQ8AUxIMslnll5qb"
        
        let expectation = XCTestExpectation(description: "Get User Public Data")
        
        do {
            let user = try await logic.getUserPublicData(from: id)
            XCTAssertEqual(user.username, "test")
            XCTAssertEqual(user.social?.instagram?.username, "testing")
            expectation.fulfill()
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testGetUserPublicDataEmptyId() async {
        let id = ""
        
        let expectation = XCTestExpectation(description: "Get User Public Data")
        
        do {
            _ = try await logic.getUserPublicData(from: id)
        } catch {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testGetUserPublicDataWrongId() async {
        let id = "test"
        
        let expectation = XCTestExpectation(description: "Get User Public Data")
        
        do {
            _ = try await logic.getUserPublicData(from: id)
        } catch {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    //    func testGetUserPublicDataIncorrectData() async {
    //        let id = "test_user_incorrect"
    //
    //        let expectation = XCTestExpectation(description: "Get User Public Data")
    //
    //        do {
    //            _ = try await logic.getUserPublicData(from: id)
    //            XCTFail("Request must not succeed")
    //            expectation.fulfill()
    //        } catch {
    //            expectation.fulfill()
    //        }
    //
    //        wait(for: [expectation], timeout: 10)
    //    }
    
    // MARK: Update Profile Picture
    // Write in emulator storage not working (but read is)
    //    func testUpdateProfilePicture() throws {
    //
    //        wait(for: [anonymousSign(for: logic)], timeout: 10)
    //
    //        let expectation = XCTestExpectation(description: "Upload Image")
    //
    //        let imageData = try file(named: "image1", extention: "jpg")
    //
    //        logic.updateProfilePicture(imageData: imageData, path: .profile) { result in
    //            switch result {
    //            case .success(let url):
    //                print(url)
    //                expectation.fulfill()
    //            case .failure(let error):
    //                XCTFail(error.localizedDescription)
    //            }
    //        }
    //
    //        wait(for: [expectation], timeout: 5)
    //    }
}
