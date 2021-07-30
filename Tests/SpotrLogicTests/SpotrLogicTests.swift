import XCTest
import Logging
@testable import SpotrLogic

let logger = Logger(label: "test.app.spotr.spotr_logic")

final class SpotrLogicTests: XCTestCase {


    override func setUp() {
        super.setUp()

        configure(firebase: fileURL(named: "GoogleService-Info", extention: "plist"), testing: true)
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.

        let expectation = XCTestExpectation(description: "Area fetching")

        let logic = SpotrLogic(logger: logger)


        logic.areas { result in
            switch result {
                case .success(let areas):
                    logger.info("areas: \(areas.count)")
                case .failure(let error):
                    logger.error("\(error)")
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10)
    }
}

// MARK: - Test Resources

internal let resourceFolder : URL = {
    var url = URL(fileURLWithPath: #file)
    url.deletePathExtension()
    url.deleteLastPathComponent()
    url.appendPathComponent("Resources")
    return url
}()

internal func file(named name: String, extention: String? = "json", in folder: URL = resourceFolder) throws -> Data {
    var url = folder
    url.appendPathComponent(name)

    if let extention = extention {
        url.appendPathExtension(extention)
    }

    return try Data(contentsOf: url)
}


internal func fileURL(named name: String, extention: String? = "json", in folder: URL = resourceFolder) -> URL {
    var url = folder
    url.appendPathComponent(name)

    if let extention = extention {
        url.appendPathExtension(extention)
    }

    return url
}
