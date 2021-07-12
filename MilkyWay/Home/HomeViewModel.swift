import Foundation
import Combine

typealias HomeOutput = AnyPublisher<HomeViewState, Never>

protocol HomeViewModelable {
    var rows: Int { get }
    func getImageViewModel(at indexPath: IndexPath) -> NasaImageViewModel?
    func getData(_ call: AnyPublisher<Void, Never>) -> HomeOutput
}

class HomeViewModel: HomeViewModelable {

    private var cancellables = Set<AnyCancellable>()
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

    func getData(_ call: AnyPublisher<Void, Never>) -> HomeOutput {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        let defaultState: HomeOutput = Just(.loading).eraseToAnyPublisher()

        let apiState = api.getImages(page: 1)
            .map { [unowned self] result -> HomeViewState in
                switch result {
                case .success(let response) where response.collection.items.isEmpty:
                    return .empty
                case .success(let response):
                    self.images = response.collection.items.compactMap { [unowned self] model in
                        NasaImageViewModel(model: model,
                                           image: self.imageLoader.downloadImage(from: model.links.first?.imageUrl)) }
                    return .success
                case .failure(let error):
                    return .failure(error: error)
                }
            }
            .eraseToAnyPublisher()

        return Publishers.Merge(defaultState, apiState)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}
