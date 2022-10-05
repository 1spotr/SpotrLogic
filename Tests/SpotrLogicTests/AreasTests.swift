//
//  AreasTests.swift
//  SpotrLogicTests
//
//  Created by Marcus on 29/10/2021.
//

import XCTest
@testable import SpotrLogic
import FirebaseFirestore
import FirebaseAuth


class AreasTests: XCTestCase {
    
    // MARK: - Config
    
    private var logic : SpotrLogic!
    
    override func setUp() {
        super.setUp()
        
        _ = configured
        
        logic = .init(logger: logger, protection: protectionSpace)
    }
    
    override func tearDown() {
        super.tearDown()
        
        logic = nil
    }
    
    private let testFolder : URL = {
        var url = resourceFolder
        url.appendPathComponent("Areas")
        return url
    }()
    
    // MARK: - Tests
    
    
    // MARK: Coding
    
    func testAreaDecodingWithGeolocation() throws {
        
        let file = try file(named: "area_singapore")
        
        var area: Area? = nil
        
        XCTAssertNoThrow(area = try decoder.decode(Area.self, from: file))
        
        guard let area = area else {
            XCTFail("No decoding area")
            return
        }
        
        XCTAssertEqual(area.id, "1aab0e35-6e44-47af-826b-3ab1c0ef6107")
        XCTAssertEqual(area.name, "Singapore")
        XCTAssertEqual(area.geolocation.longitude, 48.0)
        XCTAssertEqual(area.geolocation.latitude, 2.0)
    }
    
    // MARK: Requests
    
    func testSetResidenceArea() throws {
        
        wait(for: [anonymousSign(for: logic)], timeout: 10)
        
        /// Random test area id
								let areaId = UUID().description
        
        let expectation = XCTestExpectation(description: "Residence creation")
        
        
								try logic.setResidence(areaId: areaId, completion: { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        })
        
        
        wait(for: [expectation], timeout: 10)
        
        let verifcationExpectation = XCTestExpectation(description: "verification")
        
        
        if let userID = Auth.auth().currentUser?.uid {
            // Verifying last command for user
            
            testingFirestore.collection("commands_users")
                .whereField("type", isEqualTo: "users.settings.area.update")
                .whereField("payload.user_id", isEqualTo: userID)
                .order(by: "timestamp", descending: true)
                .getDocuments { query, error in
                    if let error = error {
                        XCTFail(error.localizedDescription)
                    }
                    
                    if let document = query?.documents.first {
                        CommandTests.verifyCommand(document)
                        XCTAssertEqual(document.get("payload.user_id") as? String, userID)
                        XCTAssertEqual(document.get("payload.area_id") as? String, areaId)
                    }
                    
                    
                    verifcationExpectation.fulfill()
                }
        } else {
            XCTFail("No auth")
        }
        
        wait(for: [verifcationExpectation], timeout: 10)
    }
    
}
