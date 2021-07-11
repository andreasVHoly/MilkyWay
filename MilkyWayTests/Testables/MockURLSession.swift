import Foundation
import XCTest
@testable import MilkyWay

class MockURLSession: URLSession {

    var data: Data?
    var error: Error?

    func loadJsonFile(_ fileName: String) {
        data = MockURLSession.loadJsonFile(fileName)
    }

    static func loadJsonFile(_ filename: String) -> Data? {
        let bundle = Bundle.init(for: MockURLSession.self)
        if let filepath = bundle.path(forResource: filename, ofType: "json") {
            do {
                let jsonString = try String(contentsOfFile: filepath)
                return jsonString.data(using: .utf8)
            } catch let error {
                XCTFail(error.localizedDescription)
            }
        } else {
            XCTFail("Invalid file path")
        }
        return nil
    }

    func setJsonData<T>(_ encodable: T) where T: Encodable {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(encodable)
            let jsonString = String(data: jsonData, encoding: .utf8)
            let testDataAsBase64 = jsonString!.data(using: .utf8)!.base64EncodedData()
            self.data = Data(base64Encoded: testDataAsBase64)
        } catch {
            XCTFail("Failed to set mock data")
        }
    }
}
