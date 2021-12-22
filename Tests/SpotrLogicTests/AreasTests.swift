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


    private let testFolder : URL = {
        var url = resourceFolder
        url.appendPathComponent("Areas")
        return url
    }()

    // MARK: - Tests


    func testSetResidenceArea() throws {

        wait(for: [anonymousSign(for: logic)], timeout: 10)

        /// Random test area
        let area = Area(id: UUID().description, name: "testing",
                        pictures: [], geolocation: .init(latitude: 0, longitude: 0), locations: [])

        let expectation = XCTestExpectation(description: "Residence creation")


        try logic.setResidence(area: area, completion: { result in
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
                        XCTAssertEqual(document.get("payload.area_id") as? String, area.id)
                    }


                    verifcationExpectation.fulfill()
                }
        } else {
            XCTFail("No auth")
        }

        wait(for: [verifcationExpectation], timeout: 10)
    }

}
