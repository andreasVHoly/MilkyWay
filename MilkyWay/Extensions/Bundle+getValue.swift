import Foundation

enum BundleKey: String {
    case baseUrl = "Base_Url"
}

extension Bundle {
    func getValue(for key: BundleKey) -> String {
        getValue(for: key.rawValue)
    }

    public func getValue(for key: String) -> String {
        // swiftlint:disable:next force_cast
        object(forInfoDictionaryKey: key) as! String
    }
}
