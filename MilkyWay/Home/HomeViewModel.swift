import Foundation
import Combine

typealias HomeOutput = AnyPublisher<HomeViewState, Never>

enum HomeViewState {
    case loading
    case success
    case empty
    case failure(error: Error)
}

extension HomeViewState: Equatable {
    static func == (lhs: HomeViewState, rhs: HomeViewState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading): return true
        case (.success, .success): return true
        case (.empty, .empty): return true
        case (.failure, .failure): return true
        default: return false
        }
    }
}

protocol HomeViewModelable {
    var rows: Int { get }
    func getImageViewModel(at indexPath: IndexPath) -> NasaImageViewModel?
    func getImageData() -> HomeOutput
}

class HomeViewModel: HomeViewModelable {

    private var cancellables = Set<AnyCancellable>()
    private var images = [NasaImageViewModel]()
    private let api: API

    init(api: API? = nil) {
        self.api = api ?? MilkyAPI()
    }

    var rows: Int {
        images.count
    }

    func getImageViewModel(at indexPath: IndexPath) -> NasaImageViewModel? {
        guard 0..<rows ~= indexPath.row else { return nil }
        return images[indexPath.row]
    }

    func getImageData() -> HomeOutput {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        let defaultState: HomeOutput = Just(.loading).eraseToAnyPublisher()
        let apiState = api.getImages(page: 1)
            .map { [weak self] result -> HomeViewState in
                switch result {
                case .success(let response) where response.collection.items.isEmpty:
                    return .empty
                case .success(let response):
                    self?.images = response.collection.items.compactMap { NasaImageViewModel(model: $0) }
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
