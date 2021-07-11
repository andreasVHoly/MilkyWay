import Foundation
import Combine

class NetworkClient {

    private var session: URLSession

    init(session: URLSession? = nil) {
        self.session = session ?? URLSession.shared
    }

    func get<T: Decodable>(endpoint: EndpointProtocol) -> AnyPublisher<T, Error> {
        guard let url = endpoint.url else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: url)
            .mapError { error in NetworkError.networkError(error)}
            .flatMap { data, response -> AnyPublisher<Data, Error> in
                guard let response = response as? HTTPURLResponse else {
                    return Fail(error: NetworkError.noResponse).eraseToAnyPublisher()
                }
                switch response.statusCode {
                case 200...299:
                    return Just(data)
                        .catch { _ in Empty().eraseToAnyPublisher() }
                        .eraseToAnyPublisher()
                case 400...499:
                    return Fail(error: NetworkError.authenticationError).eraseToAnyPublisher()
                case 500...599:
                    return Fail(error: NetworkError.serverError).eraseToAnyPublisher()
                default:
                    return Fail(error: NetworkError.networkError(nil)).eraseToAnyPublisher()
                }
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
