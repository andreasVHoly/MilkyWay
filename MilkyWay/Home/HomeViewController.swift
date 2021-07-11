import UIKit
import Combine

class HomeViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    private let viewModel: HomeViewModelable = HomeViewModel()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureViewModel()
    }

    private func configureViewModel() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        let stateOutput = viewModel.getImageData()
        stateOutput.sink { [unowned self] state in
            self.configureUI(for: state)
        }.store(in: &cancellables)
    }

    private func configureTableView() {
        tableView.register(cell: HomeTableViewCell.self)
        tableView.tableFooterView = UIView(frame: .zero)
    }

    private func configureUI(for state: HomeViewState) {
        switch state {
        case .loading:
            activityIndicator.startAnimating()
        case .empty:
            // TODO: no results
            activityIndicator.stopAnimating()
        case .failure(error: let error):
            activityIndicator.stopAnimating()
            // TODO: show error
        case .success:
            activityIndicator.stopAnimating()
            tableView.reloadData()
        }
    }
}

 extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.rows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(HomeTableViewCell.self)", for: indexPath)
        if let imageVM = viewModel.getImageViewModel(at: indexPath), let homeCell = cell as? HomeTableViewCell {
            homeCell.configure(with: imageVM)
        }
        return cell
    }
 }
