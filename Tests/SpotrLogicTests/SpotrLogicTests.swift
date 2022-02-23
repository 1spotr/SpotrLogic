import XCTest
import Logging
@testable import SpotrLogic
import FirebaseFirestore

let logger = Logger(label: "test.app.spotr.spotr_logic")

final class SpotrLogicTests: XCTestCase {


    override func setUp() {
        super.setUp()

       _ = configured
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.

        let expectation = XCTestExpectation(description: "Area fetching")

								let logic = SpotrLogic(logger: logger, protection: protectionSpace)


        logic.areas { result in
            switch result {
                case .success(let areas):
                    logger.info("areas: \(areas.count)")
                case .failure(let error):
                    XCTFail("\(error.localizedDescription).\nError: \(error)")
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10)
    }
}

// MARK: - Test Resources


/// Call this lazy value to configure the package once.
let configured : Bool = {
    configure(firebase: fileURL(named: "GoogleService-Info", extention: "plist"), testing: true)
    return true
}()

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


// MARK: Coding

let testingFirestore = Firestore.firestore()

let decoder : JSONDecoder = {
    let coder = JSONDecoder()
    coder.dateDecodingStrategy = .secondsSince1970
    return coder
}()

let encoder : JSONEncoder = {
    let coder = JSONEncoder()
    coder.dateEncodingStrategy = .secondsSince1970
    return coder
}()


func anonymousSign(for logic: SpotrLogic) -> XCTestExpectation {
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

    return expectation
}

func login(for logic: SpotrLogic, with credential: URLCredential) throws -> XCTestExpectation {
    let expectation = XCTestExpectation(description: "Login")
    try logic.login(with: credential) { result in
        switch result {
            case .success:
                break
            case .failure(let error):
                XCTFail(error.localizedDescription)
        }

        expectation.fulfill()
    }

    return expectation
}
