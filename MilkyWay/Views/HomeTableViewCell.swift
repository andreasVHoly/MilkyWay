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
        self.cellImage.image = UIImage(color: UIColor(color: .loading),
                                               size: cellImage.frame.size)
        self.title.text = viewModel.title
        self.subTitle.text = viewModel.subTitle
        cancellable = viewModel.image.sink { image in
            self.cellImage.image = image
        }
    }
}
