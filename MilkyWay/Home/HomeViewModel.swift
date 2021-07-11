import Foundation
import Combine

protocol HomeViewModelable {
    var rows: Int { get }
    func getImageViewModel(at indexPath: IndexPath) -> NasaImageViewModel?
    func getImageData(completion: @escaping (NetworkError?) -> Void)
}

class HomeViewModel: HomeViewModelable {

    private var images = [NasaImageViewModel]()
    private let api: API
    private let imageLoader: ImageLoadable

    init(api: API? = nil, imageLoader: ImageLoadable? = nil) {
        self.api = api ?? MilkyAPI()
        self.imageLoader = imageLoader ?? ImageLoader()
    }

    var rows: Int {
        images.count
    }

    func getImageViewModel(at indexPath: IndexPath) -> NasaImageViewModel? {
        guard 0..<rows ~= indexPath.row else { return nil }
        return images[indexPath.row]
    }

    func getImageData(completion: @escaping (NetworkError?) -> Void) {
        api.getImages(page: 1) { result in
            switch result {
            case .success(let response):
                self.images = response.collection.items.compactMap { [unowned self] model in
                    NasaImageViewModel(model: model,
                                       image: self.imageLoader.downloadImage(from: model.links.first?.imageUrl)) }
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
}
