import UIKit

class ImageTitleLabel: UILabel {}
class ImageSubtitleLabel: UILabel {}
class ImageDescriptionLabel: UILabel {}

class Theme {
    static func applyStyling() {
        ImageTitleLabel.appearance().textColor = UIColor(color: .title)
        ImageTitleLabel.appearance().font = UIFont.helveticaNeue(ofSize: 16, weight: .bold)
        ImageSubtitleLabel.appearance().textColor = UIColor(color: .subtTitle)
        ImageSubtitleLabel.appearance().font = UIFont.helveticaNeue(ofSize: 14, weight: .regular)
        ImageDescriptionLabel.appearance().textColor = UIColor(color: .title)
        ImageDescriptionLabel.appearance().font = UIFont.helveticaNeue(ofSize: 16, weight: .regular)
    }
}
