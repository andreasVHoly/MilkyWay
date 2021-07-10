import Foundation

protocol EndpointProtocol {
    var path: String { get }
    var query: String { get }
    var url: URL? { get }
}

enum Endpoint: EndpointProtocol {
    case getImages(Int)

    var base: String {
        Bundle.main.getValue(for: .baseUrl)
    }

    var query: String {
        switch self {
        case .getImages(let page):
            return String(format: "q=%@&page=%d", "\"\"", page)
        }
    }

    var path: String {
        switch self {
        case .getImages:
            return String(format: "%@/%@?%@", base, "search", query)
        }
    }

    var url: URL? {
        guard let encoded = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        return URL(string: encoded)
    }
}
