import XCTest
@testable import MilkyWay

class FormatterTests: XCTestCase {

    func testStringToDate() {

        let date = Date(timeIntervalSince1970: 1625950387.994513)

        XCTAssertEqual(Formatter.format(date: date), "10 Jul, 2021")
    }

    func testDateToString() {

        let apiDate = "2002-03-20T00:00:00Z"

        XCTAssertEqual(Formatter.format(string: apiDate), Date(timeIntervalSince1970: 1016582400))
    }
}
