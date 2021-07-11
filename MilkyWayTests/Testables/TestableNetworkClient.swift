import XCTest
@testable import MilkyWay
import Combine

class TestableNetworkClient: NetworkClient {

    var error: Error?
    var responseData: NasaResponse?

    override func get<T: Decodable>(endpoint: EndpointProtocol) -> AnyPublisher<T, Error> {
        if let error = error {
            return Fail(error: error).eraseToAnyPublisher()
        } else if let data = responseData as? T {
            return Just(data)
                .catch { _ in Empty().eraseToAnyPublisher() }
                .eraseToAnyPublisher()
        } else {
            XCTFail("Failed to return")
            return Fail(error: NetworkError.noResponse).eraseToAnyPublisher()
        }
    }
}
