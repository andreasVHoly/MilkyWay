import Foundation
import Combine

struct NasaImageViewModel: Equatable {
    let title, subTitle, description, imageUrl: String

    init?(model: NasaImage) {
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
    }
}
