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
}
