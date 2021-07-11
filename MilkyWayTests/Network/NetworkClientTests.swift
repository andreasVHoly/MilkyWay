import XCTest
@testable import MilkyWay
import Combine
import Foundation

struct InvalidTestEndpoint: EndpointProtocol {
    var path: String = "test"
    var query: String = ""
    var url: URL? = nil
}

class NetworkClientTests: XCTestCase {

    var sut: NetworkClient!
    var mockSession: MockURLSession!

    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        sut = NetworkClient(session: mockSession)
    }

    func testGet_invalidUrl() {

        let exp = expectation(description: "testCreate_invalidUrl")

        sut.get(endpoint: InvalidTestEndpoint()) { (result: Result<NasaResponse, NetworkError>) in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .invalidURL)
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGet_failure_400() {

        mockSession.data = Data()
        mockSession.response = HTTPURLResponse(url: URL(string: "http://test.com")!,
                                               statusCode: 400,
                                               httpVersion: nil,
                                               headerFields: nil)
        let exp = expectation(description: "testGet_failure_400")

        sut.get(endpoint: Endpoint.getImages(1)) { (result: Result<NasaResponse, NetworkError>) in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .authenticationError)
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGet_failure_500() {

        mockSession.data = Data()
        mockSession.response = HTTPURLResponse(url: URL(string: "http://test.com")!,
                                               statusCode: 500,
                                               httpVersion: nil,
                                               headerFields: nil)
        let exp = expectation(description: "testGet_failure_500")

        sut.get(endpoint: Endpoint.getImages(1)) { (result: Result<NasaResponse, NetworkError>) in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .serverError)
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGet_failure_other() {

        mockSession.error = NetworkError.authenticationError
        mockSession.data = Data()
        mockSession.response = HTTPURLResponse(url: URL(string: "http://test.com")!,
                                               statusCode: 600,
                                               httpVersion: nil,
                                               headerFields: nil)
        let exp = expectation(description: "testGet_failure_other")

        sut.get(endpoint: Endpoint.getImages(1)) { (result: Result<NasaResponse, NetworkError>) in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .networkError(NetworkError.authenticationError))
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGet_noResponse() {

        mockSession.data = nil
        mockSession.response = HTTPURLResponse(url: URL(string: "http://test.com")!,
                                               statusCode: 1,
                                               httpVersion: nil,
                                               headerFields: nil)
        let exp = expectation(description: "testGet_noResponse")

        sut.get(endpoint: Endpoint.getImages(1)) { (result: Result<NasaResponse, NetworkError>) in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .noResponse)
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGet_success() {

        mockSession.loadJsonFile("collection")
        let exp = expectation(description: "testGet_success")

        sut.get(endpoint: Endpoint.getImages(1)) { (result: Result<NasaResponse, NetworkError>) in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.collection.items.count, 100)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }
}
