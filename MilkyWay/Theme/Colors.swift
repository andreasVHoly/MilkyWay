import UIKit

enum MilkyColors: String, CaseIterable {
    case title = "Title"
    case subtTitle = "SubTitle"
    case loading = "Loading"
}

extension UIColor {
    convenience init(color: MilkyColors) {
        self.init(named: color.rawValue, in: .main, compatibleWith: nil)!
    }
}
