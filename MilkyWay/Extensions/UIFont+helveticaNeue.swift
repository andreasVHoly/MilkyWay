import UIKit

extension UIFont {

    enum FontWeight: String {
        case bold = "Bold"
        case regular = "Light" // TODO: import custom font
    }

    /**
     Convenience accessor for the HelveticaNeue Font
     - Parameter ofSize: The point size of the desired `UIFont`
     - Parameter weight: The `FontWeight` weight of the desired `UIFont`
     - Returns: A HelveticaNeue `UIFont` `with the given size and weight
     */
    static func helveticaNeue(ofSize: CGFloat, weight: FontWeight) -> UIFont {
        return UIFont(name: "HelveticaNeue-\(weight.rawValue)", size: ofSize)!
    }
}
