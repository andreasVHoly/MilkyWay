import Foundation

protocol API {
    func getImages(page: Int, completion: @escaping (Result<NasaResponse, NetworkError>) -> Void)
}

class MilkyAPI: API {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient? = nil) {
        self.networkClient = networkClient ?? NetworkClient()
    }

    func getImages(page: Int, completion: @escaping (Result<NasaResponse, NetworkError>) -> Void) {
        networkClient.get(endpoint: Endpoint.getImages(page), completion: completion)
    }
}
