import XCTest
@testable import MilkyWay
import Combine

class TestableNetworkClient: NetworkClient {

    var error: NetworkError?
    var responseData: NasaResponse?

    override func get<T>(endpoint: EndpointProtocol, completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable {
        if let error = error {
            completion(.failure(error))
        } else if let data = responseData as? T {
            completion(.success(data))
        } else {
            XCTFail("Failed to return")
            completion(.failure(.noResponse))
        }
    }
}
