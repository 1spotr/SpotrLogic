//
//  NotificationTests.swift
//  SpotrLogicTests
//
//  Created by Johann Petzold on 14/12/2021.
//

import XCTest
@testable import SpotrLogic

class NotificationTests: XCTestCase {
    
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
    
    func testNotificationFromJson() throws -> Void {
        let file = try file(named: "notif_refused")
        
        let notification: SpotrNotification = try decoder.decode(SpotrNotification.self, from: file)
        
        XCTAssertEqual(notification.id, "7f66f636-7f36-49ea-8074-dfc11954ed29")
    }
    
    func testNotification() throws -> Void {
        let loginCredentials = URLCredential(user: "test@test.spotr.app", password: "Testing", persistence: .none)
        
        wait(for: [try login(for: logic, with: loginCredentials)], timeout: 10)
        
        let expectation = XCTestExpectation(description: "Fetch Notification")
        
        try logic.notificationsForLoggedUser(completion: { result in
            switch result {
            case .success(let notifications):
                if let first = notifications.first {
                    XCTAssertEqual(first.id, "D3QN0d9WwXgN15jZ8XQX")
                    expectation.fulfill()
                } else {
                    XCTFail("Nothing to fetch")
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        })
        
        wait(for: [expectation], timeout: 10)
    }
}
