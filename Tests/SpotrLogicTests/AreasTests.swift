//
//  AreasTests.swift
//  SpotrLogicTests
//
//  Created by Marcus on 29/10/2021.
//

import XCTest
@testable import SpotrLogic

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

        waitForAnonymousSign()

        let file  = try file(named: "area", in: testFolder)

        let area = try decoder.decode(Area.self, from: file)


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

    }


    func waitForAnonymousSign() -> Void {
        let expectation = XCTestExpectation(description: "Anonymous sign")
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

}
