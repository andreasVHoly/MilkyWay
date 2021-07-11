import UIKit

extension UITableView {
    // TableView registration of a UITableViewCell Nib 
    public func register<T: UITableViewCell>(cell: T.Type) {
        register(UINib(nibName: "\(cell)", bundle: nil), forCellReuseIdentifier: "\(cell)")
    }
}
