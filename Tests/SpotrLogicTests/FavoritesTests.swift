//
//  FavoritesTests.swift
//  SpotrLogicTests
//
//  Created by Marcus on 08/09/2021.
//

import XCTest
@testable import SpotrLogic

class FavoritesTests: XCTestCase {

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

    // MARK: - Favorites Tests

    func testAddFavorite() throws -> Void {

        let file = try file(named: "spot")

        let spot = try decoder.decode(Spot.self, from: file)


        let expectation = XCTestExpectation(description: "Favorite creation")

        try logic.addToFavorite(spot: spot) { result in
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
