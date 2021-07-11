import XCTest
@testable import MilkyWay
import Combine

class NasaImageViewModelTests: XCTestCase {

    func testCreate_invalid() {
        let model1 = NasaImage(data: [NasaImageData(title: "Test3",
                                                   description: "Test description3",
                                                   dateCreated: "2021-09-11T15:00:00Z",
                                                   creator: nil,
                                                   photographer: nil)],
                              links: []
        )
        let model2 = NasaImage(data: [],
                              links: [NasaImageLink(imageUrl: "https://test3.com")]
        )

        XCTAssertNil(NasaImageViewModel(model: model1, image: Just(UIImage()).eraseToAnyPublisher()))
        XCTAssertNil(NasaImageViewModel(model: model2, image: Just(UIImage()).eraseToAnyPublisher()))
    }

    func testCreate_photographer() {

        let sut = NasaImageViewModel(model: NasaImage.testable(), image: Just(UIImage()).eraseToAnyPublisher())

        XCTAssertEqual(sut?.title, "Test")
        XCTAssertEqual(sut?.subTitle, "Tester | 11 Jul, 2021")
        XCTAssertEqual(sut?.description, "Test description")
        XCTAssertEqual(sut?.imageUrl, "https://test.com")
    }

    func testCreate_creator() {

        let sut = NasaImageViewModel(model: NasaImage.testable2(), image: Just(UIImage()).eraseToAnyPublisher())

        XCTAssertEqual(sut?.title, "Test2")
        XCTAssertEqual(sut?.subTitle, "Test Creator | 11 Aug, 2021")
        XCTAssertEqual(sut?.description, "Test description2")
        XCTAssertEqual(sut?.imageUrl, "https://test2.com")
    }

    func testCreate_no_author() {

        let model = NasaImage(data: [NasaImageData(title: "Test3",
                                                   description: "Test description3",
                                                   dateCreated: "2021-09-11T15:00:00Z",
                                                   creator: nil,
                                                   photographer: nil)],
                              links: [NasaImageLink(imageUrl: "https://test3.com")]
        )

        let sut = NasaImageViewModel(model: model, image: Just(UIImage()).eraseToAnyPublisher())

        XCTAssertEqual(sut?.title, "Test3")
        XCTAssertEqual(sut?.subTitle, "11 Sep, 2021")
        XCTAssertEqual(sut?.description, "Test description3")
        XCTAssertEqual(sut?.imageUrl, "https://test3.com")
    }

    func testCreate_no_date() {

        let model = NasaImage(data: [NasaImageData(title: "Test4",
                                                   description: "Test description4",
                                                   dateCreated: "2021-09T15:00:00Z",
                                                   creator: "John Doe",
                                                   photographer: nil)],
                              links: [NasaImageLink(imageUrl: "https://test4.com")]
        )

        let sut = NasaImageViewModel(model: model, image: Just(UIImage()).eraseToAnyPublisher())

        XCTAssertEqual(sut?.title, "Test4")
        XCTAssertEqual(sut?.subTitle, "John Doe")
        XCTAssertEqual(sut?.description, "Test description4")
        XCTAssertEqual(sut?.imageUrl, "https://test4.com")
    }
}
