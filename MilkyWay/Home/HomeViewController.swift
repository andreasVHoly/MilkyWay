import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    private let viewModel: HomeViewModelable = HomeViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let refreshControl = UIRefreshControl()

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
        refreshData()
    }

    @objc private func refreshData() {
        activityIndicator.startAnimating()
        viewModel.getImageData { error in
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
                self?.refreshControl.endRefreshing()
                if let error = error {
                    self?.showError(error: error)
                } else {
                    self?.tableView.reloadData()
                }
            }
        }
    }

    private func configureTableView() {
        tableView.refreshControl = refreshControl
        tableView.register(cell: HomeTableViewCell.self)
        tableView.tableFooterView = UIView(frame: .zero)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vm = viewModel.getImageViewModel(at: indexPath) else { return }
        let controller: NasaImageDetailViewController = Controller.imageDetail.create()
        controller.viewModel = vm
        self.navigationController?.pushViewController(controller, animated: true)
    }
 }
