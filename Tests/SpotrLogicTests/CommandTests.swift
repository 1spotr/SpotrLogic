//
//  CommandTests.swift
//  SpotrLogicTests
//
//  Created by Marcus on 09/11/2021.
//

import XCTest
@testable import SpotrLogic
import FirebaseFirestore

class CommandTests: XCTestCase {


    class func verifyCommand(_ document: QueryDocumentSnapshot) -> Void {

        XCTAssertNotNil(document.get("id") as? String , "id must exist")
        XCTAssertNil(document.get("event_id") as? String, "event_id should be null")
        XCTAssertNotNil(document.get("timestamp"), "timestamp must be valid")
        XCTAssertEqual(document.get("origin") as? String, "ios", "origin is not valid")
        XCTAssertNotNil(document.get("trace_id") as? String, "trace_id must exist")
    }
}
