import UIKit

public extension UIImage {
    /**
        Initializes and returns an image object with the specified solid `UIColor`
     - Parameter color: The color of the `UIImage`
     - Parameter size: The size of the `UIImage`
     */
    convenience init?(color: UIColor, size: CGSize) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
