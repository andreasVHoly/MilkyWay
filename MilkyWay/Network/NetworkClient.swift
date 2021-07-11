import Foundation
import Combine

class NetworkClient {

    private var session: URLSession

    init(session: URLSession? = nil) {
        self.session = session ?? URLSession.shared
    }

    func get<T: Decodable>(endpoint: EndpointProtocol, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = endpoint.url else {
            completion(.failure(.invalidURL))
            return
        }

        let request = URLRequest(url: url)
        self.createTask(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decoded))
                } catch let DecodingError.dataCorrupted(context) {
                    let errorMessage = "Data Corrupted Parsing Error: \(context)"
                    return completion(.failure(.parsingError(errorMessage)))
                } catch let DecodingError.keyNotFound(key, context) {
                    let errorMessage = "Key '\(key)' not found: \(context.debugDescription)"
                    return completion(.failure(.parsingError(errorMessage)))
                } catch let DecodingError.valueNotFound(value, context) {
                    let errorMessage = "Value '\(value)' not found: \(context.debugDescription)"
                    return completion(.failure(.parsingError(errorMessage)))
                } catch let DecodingError.typeMismatch(type, context) {
                    let errorMessage = "Parsing Mismatch Error: Type '\(type)' mismatch: \(context.debugDescription)"
                    return completion(.failure(.parsingError(errorMessage)))
                } catch {
                    return completion(.failure(.parsingError(error.localizedDescription)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    fileprivate func createTask(request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let task = self.session.dataTask(with: request) { data, networkResponse, error in
            if let response = networkResponse as? HTTPURLResponse,
                let data = data {
                switch response.statusCode {
                case 200...299:
                    completion(.success(data))
                case 400...499:
                    completion(.failure(NetworkError.authenticationError))
                case 500...599:
                    completion(.failure(NetworkError.serverError))
                default:
                    completion(.failure(NetworkError.networkError(error)))
                }
            } else {
                completion(.failure(NetworkError.noResponse))
            }
        }
        task.resume()
    }
}
