import Foundation
import XCTest
@testable import MilkyWay

class MockURLSession: URLSession {

    var data: Data?
    var error: Error?
    var response: URLResponse?

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

    override func dataTask(with url: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return MockDataTask(data: self.data,
                            error: self.error,
                            response: self.response,
                            completion: completionHandler)
    }
}

class MockDataTask: URLSessionDataTask {
    var completion: ((Data?, URLResponse?, Error?) -> Void)?
    var testData: Data?
    let testResponse: URLResponse
    var testError: Error?

    init(data: Data?, error: Error?, response: URLResponse?, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.testData = data
        self.testError = error
        self.testResponse = response ?? HTTPURLResponse(url: URL(string: "http://test.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        self.completion = completion
    }

    override func resume() {
        completion?(testData, testResponse, testError)
    }
}
