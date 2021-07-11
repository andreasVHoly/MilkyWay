import Foundation
@testable import MilkyWay


extension NasaResponse {
    static func testable() -> NasaResponse {
        return NasaResponse(collection:
                                NasaCollection(items: [NasaImage.testable(),
                                                       NasaImage.testable2()])
        )
    }
}

extension NasaImage {
    static func testable() -> NasaImage {
        NasaImage(data: [
                    NasaImageData(title: "Test",
                                  description: "Test description",
                                  dateCreated: "2021-07-11T15:00:00Z",
                                  creator: nil,
                                  photographer: "Tester")],
                  links: [
                    NasaImageLink(imageUrl: "https://test.com")]
        )
    }

    static func testable2() -> NasaImage {
        NasaImage(data: [NasaImageData(title: "Test2",
                                  description: "Test description2",
                                  dateCreated: "2021-08-11T15:00:00Z",
                                  creator: "Test Creator",
                                  photographer: nil)],
                  links: [NasaImageLink(imageUrl: "https://test2.com")]
        )
    }
}
