import UIKit
import Combine

class HomeViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    private let viewModel: HomeViewModelable = HomeViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let refreshControl = UIRefreshControl()
    private let getData = PassthroughSubject<Void, Never>()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureViewModel()
    }

    private func configureViewModel() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        let stateOutput = viewModel.getData(getData.eraseToAnyPublisher())
        stateOutput.sink { [unowned self] state in
            self.configureUI(for: state)
        }.store(in: &cancellables)
    }

    private func configureTableView() {
        tableView.refreshControl = refreshControl
        tableView.register(cell: HomeTableViewCell.self)
        tableView.tableFooterView = UIView(frame: .zero)
        refreshControl.addTarget(self, action: #selector(pulledToRefresh), for: .valueChanged)
    }

    @objc
    private func pulledToRefresh() {
        getData.send()
    }

    private func showError(error: NetworkError) {
        let alert = UIAlertController(title: "That didn't work!",
                                      message: error.errorDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
            self?.getData.send()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            alert.dismiss(animated: true)
        }))
        self.present(alert, animated: true)
    }

    private func configureUI(for state: HomeViewState) {
        switch state {
        case .loading:
            activityIndicator.startAnimating()
        case .empty:
            activityIndicator.stopAnimating()
            refreshControl.endRefreshing()
            showError(error: .noResults)
        case .failure(error: let error):
            activityIndicator.stopAnimating()
            refreshControl.endRefreshing()
            showError(error: error)
        case .success:
            activityIndicator.stopAnimating()
            refreshControl.endRefreshing()
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
