@testable import MilkyWay
import Combine

class TestableAPI: API {

    var error: NetworkError?
    var response = NasaResponse.testable()

    func getImages(page: Int) -> ImageResponse {
        if let error = error {
            return Just(.failure(error)).eraseToAnyPublisher()
        } else {
            return Just(.success(response)).eraseToAnyPublisher()
        }
    }
}
