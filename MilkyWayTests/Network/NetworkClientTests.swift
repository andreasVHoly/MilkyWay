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

    override func setUp() {
        super.setUp()
        sut = NetworkClient(session: MockURLSession())
    }

    func testCreate_invalidUrl() {

        let exp = expectation(description: "testCreate_invalidUrl")

        let result = sut.get(endpoint: InvalidTestEndpoint())
            .map { (value: NasaResponse) in
                XCTFail("Received success")
                exp.fulfill()
                return .success(value)
            }
            .catch { error -> AnyPublisher<Result<NasaResponse, Error>, Never> in
                guard let error = error as? NetworkError,
                      case NetworkError.invalidURL = error else {
                    XCTFail("Invalid error thrown ")
                    return Just(.failure(error))
                        .catch { _ in Empty().eraseToAnyPublisher() }
                        .eraseToAnyPublisher()
                }
                exp.fulfill()
                return Just(.failure(error))
                    .catch { _ in Empty().eraseToAnyPublisher() }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        _ = result.sink { _ in }

        wait(for: [exp], timeout: 0.1)
    }
}
