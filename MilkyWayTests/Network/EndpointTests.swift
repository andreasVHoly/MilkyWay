import XCTest
@testable import MilkyWay

class EndpointTests: XCTestCase {

    func test_getPreferences_staging() {

        let sut = Endpoint.getImages(1)

        XCTAssertEqual(sut.base, "https://images-api.nasa.gov")
        XCTAssertEqual(sut.path, "https://images-api.nasa.gov/search?q=\"\"&page=1")
        XCTAssertEqual(sut.query, "q=\"\"&page=1")
        XCTAssertNotNil(sut.url)
    }
}
