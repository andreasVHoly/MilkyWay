import Foundation
import XCTest

func readJSONData(_ fileName: String) -> Data? {
    guard let path = Bundle(for: NasaCollectionTests.classForCoder())
            .path(forResource: fileName, ofType: "json") else {
        XCTFail("Failed to get path for file: \(fileName)")
        return nil
    }
    do {
        return try Data(contentsOf: URL(fileURLWithPath: path))
    } catch {
        XCTFail("Failed to convert file \(fileName) into Data")
        return nil
    }
}
