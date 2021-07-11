import Foundation

enum NetworkError: Error {
    case invalidURL
    case authenticationError
    case serverError
    case networkError(Error?)
    case noResponse
    case parsingError(String)
}
