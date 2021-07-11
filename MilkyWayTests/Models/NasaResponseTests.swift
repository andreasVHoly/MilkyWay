import XCTest
@testable import MilkyWay

class NasaResponseTests: XCTestCase {

    func testCreate() {

        guard let json = MockURLSession.loadJsonFile("collection") else {
            XCTFail("Failed to read json file")
            return
        }

        do {
            let sut = try JSONDecoder().decode(NasaResponse.self, from: json)
            XCTAssertEqual(sut.collection.items.count, 100)
        } catch {
            XCTFail(String(describing: error))
        }
    }
}
