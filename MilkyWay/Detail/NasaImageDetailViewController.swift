import UIKit
import Combine

class NasaImageDetailViewController: UIViewController {

    @IBOutlet weak var labelStack: UIStackView!
    @IBOutlet weak var titleLabel: ImageTitleLabel!
    @IBOutlet weak var subTitle: ImageSubtitleLabel!
    @IBOutlet weak var descriptionLabel: ImageDescriptionLabel!
    @IBOutlet weak var image: UIImageView! {
        didSet {
            image.image = UIImage(color: UIColor(color: .loading),
                                  size: image.frame.size)
        }
    }
    private var cancellable: AnyCancellable?

    var viewModel: NasaImageViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    private func configureView() {
        self.navigationItem.largeTitleDisplayMode = .never
        labelStack.setCustomSpacing(24, after: subTitle)
        titleLabel.text = viewModel.title
        subTitle.text = viewModel.subTitle
        descriptionLabel.text = viewModel.description
        cancellable = viewModel.image.sink { image in
            self.image.image = image
        }
    }
}

