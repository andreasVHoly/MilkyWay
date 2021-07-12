import Foundation
import UIKit
import Combine

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var title: ImageTitleLabel!
    @IBOutlet weak var subTitle: ImageSubtitleLabel!
    private var cancellable: AnyCancellable?

    override func prepareForReuse() {
        super.prepareForReuse()
        stopImageLoading()
    }

    private func stopImageLoading() {
        cellImage.image = nil
        cancellable?.cancel()
    }

    func configure(with viewModel: NasaImageViewModel) {
        stopImageLoading()
        self.title.text = viewModel.title
        self.subTitle.text = viewModel.subTitle
        cancellable = viewModel.image.sink { [unowned self] image in
            if let downloaded = image {
                self.cellImage.image = downloaded
            }
        }
    }
}
