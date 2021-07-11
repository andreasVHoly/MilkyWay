import Foundation
import Combine

protocol ImageLoadable {
    func downloadImage(from url: String?) -> ImageClientResponse
}

class ImageLoader: ImageLoadable {
    private let imageClient: ImageClient

    init(imageClient: ImageClient? = nil) {
        self.imageClient = imageClient ?? ImageClient()
    }

    func downloadImage(from url: String?) -> ImageClientResponse {
        guard let unwrapped = url, let url = URL(string: unwrapped) else {
            return Just(nil).eraseToAnyPublisher()
        }
        return imageClient.downloadImage(from: url)
            .map { $0 }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
