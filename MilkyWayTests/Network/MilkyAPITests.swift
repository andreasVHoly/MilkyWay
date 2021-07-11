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

        _ = sut.getImages(page: 1).sink(receiveValue: { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.collection.items.count, 2)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            exp.fulfill()
        }).store(in: &cancellables)

        wait(for: [exp], timeout: 0.1)
    }

    func testGetImages_fail() {

        client.error = NetworkError.authenticationError
        let exp = expectation(description: "testGetImages_fail")

        let output = sut.getImages(page: 1).sink(receiveValue: { result in
            switch result {
            case .success(let response):
                XCTFail("Should have an error")
                XCTAssertEqual(response.collection.items.count, 2)
            case .failure(let error):
                XCTAssertTrue(error is NetworkError)
            }
            exp.fulfill()
        }).store(in: &cancellables)

        wait(for: [exp], timeout: 0.1)
    }
}
