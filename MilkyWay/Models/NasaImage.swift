import Foundation

struct NasaImage: Decodable {
    let data: [NasaImageData]
    let links: [NasaImageLink]
}

struct NasaImageData: Decodable {
    let title, description, dateCreated: String
    let creator, photographer: String?

    enum CodingKeys: String, CodingKey {
        case title, photographer, description
        case dateCreated = "date_created"
        case creator = "secondary_creator"
    }
}

struct NasaImageLink: Decodable {
    let imageUrl: String

    enum CodingKeys: String, CodingKey {
        case imageUrl = "href"
    }
}
