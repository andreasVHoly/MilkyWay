import XCTest
@testable import MilkyWay
import Combine

class MilkyAPITests: XCTestCase {

    var sut: MilkyAPI!
    var client: TestableNetworkClient!
    var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        client = TestableNetworkClient()
        sut = MilkyAPI(networkClient: client)
    }

    func testGetImages_success() {

        client.responseData = NasaResponse.testable()
        let exp = expectation(description: "testGetImages_success")

        sut.getImages(page: 1) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.collection.items.count, 2)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetImages_fail() {

        client.error = NetworkError.authenticationError
        let exp = expectation(description: "testGetImages_fail")

        sut.getImages(page: 1) { result in
            switch result {
            case .success:
                XCTFail("Should have an error")
            case .failure(let error):
                XCTAssertEqual(error, .authenticationError)
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }
}
