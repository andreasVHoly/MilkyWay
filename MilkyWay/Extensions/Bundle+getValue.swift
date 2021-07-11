import Foundation

enum BundleKey: String {
    case baseUrl = "Base_Url"
}

extension Bundle {
    /**
        Accesses values in the app's Bundle with the specified `BundleKey`
     - Parameter key: The key to be looked up
     - Returns: The Value stored under the key
     - Warning: Be sure this value exists in your Bundle, as a missing value can cause a crash
     */
    func getValue(for key: BundleKey) -> String {
        getValue(for: key.rawValue)
    }

    private func getValue(for key: String) -> String {
        // swiftlint:disable:next force_cast
        object(forInfoDictionaryKey: key) as! String
    }
}
