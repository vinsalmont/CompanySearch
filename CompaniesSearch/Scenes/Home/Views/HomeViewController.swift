//
//  HomeViewController.swift
//  CompaniesSearch
//
//  Created by Vinicius Salmont on 11/01/21.
//

import UIKit
import Lottie

protocol HomeDisplayLogic: class {
    func showError(message: String)
    func showCompanies(viewModel: HomeModels.FetchCompanies.ViewModel)
}

class HomeViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var lottieViewPlaceholder: UIView!
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var paginationButtonsView: UIView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!

    // MARK: - Properties
    var interactor: HomeBusinessLogic?
    var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?
    private let companyCellIdentifier = "CompanyTableViewCell"
    private var animationView: AnimationView?
    private var displayedCompanies = [HomeModels.FetchCompanies.ViewModel.DisplayedCompany]()
    private var query = ""
    private var previousURL: String?
    private var nextURL: String?

    // MARK: - Initialization
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup
    private func setup() {
        let viewController = self
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()

        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCell()
        initialPlaceholder()
        setupNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - NavigationBar
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true

        let search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.delegate = self

        self.navigationItem.searchController = search
    }

    // MARK: - Lottie Configuration
    private func setupLottie(animationView: AnimationView) {
        animationView.frame = lottieViewPlaceholder.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5

        lottieViewPlaceholder.subviews.forEach { $0.removeFromSuperview() }
        lottieViewPlaceholder.addSubview(animationView)

        animationView.play()
    }

    func initialPlaceholder() {
        placeholderView.isHidden = false
        paginationButtonsView.isHidden = true
        placeholderLabel.text = "Search a keyword above."

        animationView = .init(name: "search")
        if let animationView = animationView {
            setupLottie(animationView: animationView)
        }
    }

    func errorPlaceholder() {
        placeholderView.isHidden = false
        paginationButtonsView.isHidden = true
        placeholderLabel.text = "Woops! Nothing found here =/"

        animationView = .init(name: "empty")
        if let animationView = animationView {
            setupLottie(animationView: animationView)
        }
    }

    func loadinglaceholder() {
        placeholderView.isHidden = false
        paginationButtonsView.isHidden = true
        placeholderLabel.text = "Searching"

        animationView = .init(name: "searching")
        if let animationView = animationView {
            setupLottie(animationView: animationView)
        }
    }

    func hidePlaceholder() {
        placeholderView.isHidden = true
    }

    // MARK: - Methods
    @objc private func fetchCompanies(_ searchBar: UISearchBar) {
        displayedCompanies = []

        guard let query = searchBar.text, query.trimmingCharacters(in: .whitespaces) != "" else {
            initialPlaceholder()
            tableView.reloadData()
            return
        }

        loadinglaceholder()

        self.query = query

        let request = HomeModels.FetchCompanies.Search(query: query)
        interactor?.searchCompanies(request: request)
    }

    private func paginateCompanies(url: String) {
        let request = HomeModels.FetchCompanies.Paginate(url: url)
        interactor?.paginateCompanies(request: request)
    }

    // MARK: Setup Table View
    private func registerTableViewCell() {
        tableView.delegate = self
        tableView.dataSource = self

        let cell = UINib(nibName: companyCellIdentifier, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: companyCellIdentifier)
    }

    // MARK: - IBActions
    @IBAction func previousButtonTapped(_ sender: Any) {
        guard  let previousURL = self.previousURL else { return }
        let request = HomeModels.FetchCompanies.Paginate(url: previousURL)
        interactor?.paginateCompanies(request: request)
    }

    @IBAction func nextButtonTapped(_ sender: Any) {
        guard  let nextURL = self.nextURL else { return }
        let request = HomeModels.FetchCompanies.Paginate(url: nextURL)
        interactor?.paginateCompanies(request: request)
    }

}

// MARK: UITableViewDataSource && UITableViewDelegate
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedCompanies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: companyCellIdentifier, for: indexPath) as? CompanyTableViewCell else { return UITableViewCell() }

        let displayedCompany = displayedCompanies[indexPath.row]

        cell.setup(viewModel: displayedCompany)

        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = displayedCompanies[indexPath.row].loginURL,
              let name = displayedCompanies[indexPath.row].longName else {
            router?.showNoURLAlert()
            return
        }
        router?.showWebview(url: url, name: name)
    }
}

// MARK: HomeDisplayLogic
extension HomeViewController: HomeDisplayLogic {
    func showCompanies(viewModel: HomeModels.FetchCompanies.ViewModel) {

        displayedCompanies = viewModel.displayedCompanies

        if displayedCompanies.isEmpty {
            errorPlaceholder()
        } else {
            paginationButtonsView.isHidden = false
            hidePlaceholder()
        }

        if let nextURL = viewModel.nextUrl, URL(string: nextURL) != nil {
            nextButton.isEnabled = true
            self.nextURL = nextURL
        } else {
            nextButton.isEnabled = false
            self.nextURL = nil
        }

        if let previousURL = viewModel.previousUrl, URL(string: previousURL) != nil {
            previousButton.isEnabled = true
            self.previousURL  = previousURL
        } else {
            previousButton.isEnabled = false
            self.previousURL = nil
        }

        tableView.reloadData()
    }

    func showError(message: String) {
        errorPlaceholder()
    }

}

// MARK: UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        initialPlaceholder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.fetchCompanies(_:)), object: searchBar)
        perform(#selector(self.fetchCompanies(_:)), with: searchBar, afterDelay: 0.40)
    }
}

