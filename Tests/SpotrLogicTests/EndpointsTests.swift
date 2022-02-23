//
//  EndpointsTests.swift
//  SpotrLogicTests
//
//  Created by Marcus on 19/02/2022.
//

import XCTest
@testable import SpotrLogic

let protectionSpace = URLProtectionSpace(host: "localhost", port: 8080, protocol: "http", realm: nil, authenticationMethod: nil)

class EndpointsTests: XCTestCase {

				private let endpoints : Endpoints = .init(protection: protectionSpace)

				// MARK: - Endpoint

				func testMainURL() {
								guard let main = endpoints.main.url else {
												failedTorCreate(url: "main")
												return
								}


								XCTAssertEqual(main.host, protectionSpace.host,
																							"Main URL host is invalid")

								XCTAssertEqual(main.scheme, protectionSpace.protocol,
																							"Main URL protocol is invalid")

								XCTAssertEqual(main.port, protectionSpace.port,
																							"Main URL port is invalid")

				}

				// MARK: - Remote
				func testRemoteLocalizations() {
								let urlPath = "/localizations"

								guard let url = endpoints.remote(.localizations) else {
												failedTorCreate(url: Endpoints.Remote.localizations.rawValue)
												return
								}

								XCTAssertEqual(url.path, urlPath,
																							invalidPathFor(url: urlPath))
				}

				// MARK: - Misc

				private func failedTorCreate(url: String) -> Void {
								XCTFail("Impossible to create \(url) URL")
				}

				private func invalidPathFor(url: String) -> String {
								"Invalid path for \(url) URL"
				}
}
