import Foundation
import UIKit

 enum Storyboard: String {
    case home = "Home"
    case details = "Detail"

    func create() -> UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }

    var initialController: UIViewController {
        create().instantiateInitialViewController()!
    }
 }

 enum Controller: String {
    case home = "HomeViewController"
    case imageDetail = "NasaImageDetailViewController"

    func create<T: UIViewController>() -> T {
        // swiftlint:disable:next force_cast
        return self.storyboard.create().instantiateViewController(withIdentifier: self.rawValue) as! T
    }

    private var storyboard: Storyboard {
        switch self {
        case .imageDetail: return .details
        case .home: return .home
        }
    }
 }
