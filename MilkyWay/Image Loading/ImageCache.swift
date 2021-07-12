import Foundation
import UIKit

protocol ImageCachable {
    func retrieveImage(for url: URL) -> UIImage?
    func store(image: UIImage, for url: URL)
    func deleteImage(for url: URL)
    func clear()
}

class ImageCache: ImageCachable {

    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = itemLimit
        cache.totalCostLimit = memoryLimit
        return cache
    }()
    private let itemLimit, memoryLimit: Int
    private let lock = NSLock()

    init(itemLimit: Int = 200, memoryLimit: Int = 104857600) { // 100 MB
        self.itemLimit = itemLimit
        self.memoryLimit = memoryLimit
    }

    func retrieveImage(for url: URL) -> UIImage? {
        lock.lock(); defer { lock.unlock() }
        return imageCache.object(forKey: url as AnyObject) as? UIImage
    }

    func store(image: UIImage, for url: URL) {
        lock.lock(); defer { lock.unlock() }
        imageCache.setObject(image, forKey: url as AnyObject)
    }

    func deleteImage(for url: URL) {
        lock.lock(); defer { lock.unlock() }
        imageCache.removeObject(forKey: url as AnyObject)
    }

    func clear() {
        lock.lock(); defer { lock.unlock() }
        imageCache.removeAllObjects()
    }
}
