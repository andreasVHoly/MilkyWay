import Foundation

struct NasaImageViewModel {
    let title, subTitle, description, imageUrl: String
    var image: ImageClientResponse

    init?(model: NasaImage, image: ImageClientResponse) {
        guard let data = model.data.first,
              let links = model.links.first else {
            return nil
        }
        self.title = data.title
        self.description = data.description
        self.imageUrl = links.imageUrl
        var parts = [String]()
        if let author = data.photographer ?? data.creator {
            parts.append(author)
        }
        if let date = Formatter.format(string: data.dateCreated) {
            parts.append(Formatter.format(date: date))
        }
        subTitle = parts.joined(separator: " | ")
        self.image = image
    }
}
extension NasaImageViewModel: Equatable {
    static func == (lhs: NasaImageViewModel, rhs: NasaImageViewModel) -> Bool {
        return lhs.title == rhs.title &&
            lhs.subTitle == rhs.subTitle &&
            lhs.description == rhs.description &&
            lhs.imageUrl == rhs.imageUrl
    }
}
