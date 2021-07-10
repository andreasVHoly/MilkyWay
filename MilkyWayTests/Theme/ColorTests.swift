import XCTest
@testable import MilkyWay

class MilkyColorTests: XCTestCase {

    func testAllDynamicColorsLoadFromCatalog() {
        let allKnownColors = MilkyColors.allCases
        for name in allKnownColors {
            XCTAssertNotNil(UIColor(named: name.rawValue, in: .main, compatibleWith: nil), "Missing color in asset catalog named \(name)")
        }
    }
}
