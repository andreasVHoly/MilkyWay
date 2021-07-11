import Foundation
import Combine

typealias ImageResponse = AnyPublisher<Result<NasaResponse, Error>, Never>

protocol API {
    func getImages(page: Int) -> ImageResponse
}

class MilkyAPI: API {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient? = nil) {
        self.networkClient = networkClient ?? NetworkClient()
    }

    func getImages(page: Int) -> ImageResponse {
        return networkClient.get(endpoint: Endpoint.getImages(page))
            .map { .success($0) }
            .catch { error -> ImageResponse in
                return Just(.failure(error))
                    .catch { _ in Empty().eraseToAnyPublisher() }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
