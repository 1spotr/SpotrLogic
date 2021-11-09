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
        XCTAssertNotNil(document.value(forKey:"id") as? String , "id must exist")
        XCTAssertNil(document.value(forKey:"event_id") as? String, "event_id should be null")
        XCTAssertEqual(document.value(forKey: "timestamp") as? String, "timestamp must be valid")
        XCTAssertEqual(document.value(forKey: "origin") as? String, "ios", "origin is not valid")
        XCTAssertNotNil(document.value(forKey:"trace_id") as? String, "trace_id must exist")
    }
}
