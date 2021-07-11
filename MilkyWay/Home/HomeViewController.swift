import UIKit
import Combine

class HomeViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    private let viewModel: HomeViewModelable = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        refreshData()
    }

    private func refreshData() {
        activityIndicator.startAnimating()
        viewModel.getImageData { error in
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
                if let error = error {
                    self?.showError(error: error)
                } else {
                    self?.tableView.reloadData()
                }
            }
        }
    }

    private func showError(error: NetworkError) {
        let alert = UIAlertController(title: "That didn't work!",
                                      message: error.errorDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] action in
            switch action.style {
            case .default:
                self?.refreshData()
            default: break
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }

    private func configureTableView() {
        tableView.register(cell: HomeTableViewCell.self)
        tableView.tableFooterView = UIView(frame: .zero)
    }
}

 extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.rows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(HomeTableViewCell.self)", for: indexPath)
        if let imageVM = viewModel.getImageViewModel(at: indexPath),
           let homeCell = cell as? HomeTableViewCell {
            homeCell.configure(with: imageVM)
        }
        return cell
    }
 }
