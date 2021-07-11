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
    }

}
