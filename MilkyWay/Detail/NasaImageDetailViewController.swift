import UIKit

class NasaImageDetailViewModel {

}

class NasaImageDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: ImageTitleLabel!
    @IBOutlet weak var subTitle: ImageSubtitleLabel!
    @IBOutlet weak var descriptionLabel: ImageDescriptionLabel!
    @IBOutlet weak var image: UIImageView!

    private var viewModel: NasaImageDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
    }

    private func configureViewModel() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        let stateOutput = viewModel.getState()
        stateOutput.sink { [unowned self] state in
            self.configureUI(for: state)
        }.store(in: &cancellables)
    }

    private func configureUI(for state: HomeViewState) {
        switch state {
        case .loading:
        case .failure(error: let error):
            // TODO: show error
        case .success:
            
        }
    }
}

