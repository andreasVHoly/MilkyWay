import Foundation

struct NasaResponse: Decodable {
    let collection: NasaCollection
}

struct NasaCollection: Decodable {
    let items: [NasaImage]
}
