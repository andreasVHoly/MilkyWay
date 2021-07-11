import XCTest
@testable import MilkyWay
import Combine

class HomeViewModelTests: XCTestCase {

    var cancellables = Set<AnyCancellable>()
    var mockAPI: TestableAPI!
    var sut: HomeViewModel!

    override func setUp() {
        super.setUp()
        mockAPI = TestableAPI()
        sut = HomeViewModel(api: mockAPI)
    }

    func testCreate() {

        XCTAssertEqual(sut.rows, 0)
        XCTAssertNil(sut.getImageViewModel(at: IndexPath(row: 0, section: 0)))
    }

    func test_getImageData_success() {

        let exp = expectation(description: "test_getImageData_success")

        sut.getImageData() { error in
            XCTAssertNil(error)
            XCTAssertEqual(self.sut.rows, 2)
            XCTAssertNotNil(self.sut.getImageViewModel(at: IndexPath(row: 0, section: 0)))
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func test_getImageData_error() {

        mockAPI.error = NetworkError.serverError
        let exp = expectation(description: "test_getImageData_error")

        sut.getImageData() { error in
            XCTAssertEqual(error, .serverError)
            XCTAssertEqual(self.sut.rows, 0)
            XCTAssertNil(self.sut.getImageViewModel(at: IndexPath(row: 0, section: 0)))
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }
}
