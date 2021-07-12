import Foundation

enum NetworkError: Error {
    case invalidURL
    case authenticationError
    case serverError
    case networkError(Error?)
    case noResponse
    case parsingError(String)
    case noResults

    var errorDescription: String {
        switch self {
        case .networkError:
            return "Network problem. Please check your internet connection and try again"
        case .noResults:
            return "Looks like there were no results. Please try again later."
        default:
            return "Looks like something went wrong. The team will look into this ASAP."
        }
    }
}

extension NetworkError: Equatable {
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL): return true
        case (.authenticationError, .authenticationError): return true
        case (.serverError, .serverError): return true
        case (.noResponse, .noResponse): return true
        case (.noResults, .noResults): return true
        case (.networkError(let lhsError), .networkError(let rhsError)): return lhsError?.localizedDescription == rhsError?.localizedDescription
        case (.parsingError(let lhsError), .parsingError(let rhsError)): return lhsError == rhsError
        default: return false
        }
    }
}
