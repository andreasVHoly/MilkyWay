import Foundation
import Combine
import UIKit.UIColor
import UIKit.UIImage

protocol ImageLoadable {
    func downloadImage(from url: String?) -> ImageClientResponse
}

class ImageLoader: ImageLoadable {
    private let imageClient: ImageClient
    static let placeHolder = UIImage(color: UIColor(color: .loading),
                                        size: CGSize(width: 100, height: 100))

    init(imageClient: ImageClient? = nil) {
        self.imageClient = imageClient ?? ImageClient()
    }

    func downloadImage(from url: String?) -> ImageClientResponse {
        let placeholder: ImageClientResponse = Just(ImageLoader.placeHolder)
            .eraseToAnyPublisher()
        guard let unwrapped = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: unwrapped) else {
            return placeholder.eraseToAnyPublisher()
        }

        let imageDownload = imageClient.downloadImage(from: url)
            .map { $0 }
            .eraseToAnyPublisher()

        return Publishers.Merge(placeholder, imageDownload)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
