import Foundation
import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var title: ImageTitleLabel!
    @IBOutlet weak var subTitle: ImageSubtitleLabel!

    func configure(with viewModel: NasaImageViewModel) {
        // TODO: image loading
        self.cellImage.image = UIImage(color: UIColor(color: .loading),
                                            size: cellImage.frame.size)
        self.title.text = viewModel.title
        self.subTitle.text = viewModel.subTitle
    }
}
