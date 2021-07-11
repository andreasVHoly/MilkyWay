@testable import MilkyWay
import Combine

class TestableAPI: API {

    var error: NetworkError?
    var response = NasaResponse.testable()

    func getImages(page: Int, completion: @escaping (Result<NasaResponse, NetworkError>) -> Void) {
        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success(response))
        }
    }
}
