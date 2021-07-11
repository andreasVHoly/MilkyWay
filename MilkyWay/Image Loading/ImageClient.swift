import Foundation
import Combine
import UIKit

typealias ImageClientResponse = AnyPublisher<UIImage?, Never>

class ImageClient {

    private let cache: ImageCachable
    private let session: URLSession

    init(cache: ImageCachable? = nil, session: URLSession? = nil) {
        self.cache = cache ?? ImageCache()
        self.session = session ?? URLSession.shared
    }

    func downloadImage(from url: URL) -> ImageClientResponse {
        if let existing = cache.retrieveImage(for: url) {
            return Just(existing).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: url)
            .map { (data, _) -> UIImage? in
                return UIImage(data: data)
            }
            .catch { _ in
                return Just(nil)
            }
            .handleEvents(receiveOutput: { [unowned self] image in
                guard let image = image else { return }
                self.cache.store(image: image, for: url)
            })
            .eraseToAnyPublisher()
    }
}
