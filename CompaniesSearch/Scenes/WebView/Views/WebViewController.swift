//
//  WebViewController.swift
//  CompaniesSearch
//
//  Created by Vinicius Salmont on 11/01/21.
//

import UIKit
import WebKit
import Lottie

protocol WebViewDisplayLogic: class {
    func showWebView(viewModel: WebViewModels.GetURL.ViewModel)
}

class WebViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var placeholderContainer: UIView!
    @IBOutlet weak var lottiePlaceholderView: UIView!

    // MARK: - Properties
    var interactor: WebViewBusinessLogic?
    var router: (NSObjectProtocol & WebViewDataPassing)?
    private var animationView: AnimationView?

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
        let interactor = WebViewInteractor()
        let presenter = WebViewPresenter()
        let router = WebViewRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupWebView()
        getURL()
    }

    // MARK: - Methods
    private func setupWebView() {
        webView.navigationDelegate = self

        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.isUserInteractionEnabled = true
    }

    private func setupNavigation() {
        navigationItem.largeTitleDisplayMode = .never
    }

    private func getURL() {
        setPlaceholder(status: .loading)

        interactor?.getURL()
    }

    private func setupLottie(animationView: AnimationView) {
        animationView.frame = lottiePlaceholderView.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5

        lottiePlaceholderView.subviews.forEach { $0.removeFromSuperview() }
        lottiePlaceholderView.addSubview(animationView)

        animationView.play()
    }

    private func setPlaceholder(status: PlaceholderStatus) {
        placeholderContainer.isHidden = false
        switch status {
        case .loading:
            animationView = .init(name: "searching")
            if let animationView = animationView {
                setupLottie(animationView: animationView)
            }
        case .failure:
            animationView = .init(name: "empty")
            if let animationView = animationView {
                setupLottie(animationView: animationView)
            }
        case .success:
            placeholderContainer.isHidden = true
        }
    }

    // MARK: - IBAction
    @IBAction func loggedinTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - WebDisplayLogic
extension WebViewController: WebViewDisplayLogic {
    func showWebView(viewModel: WebViewModels.GetURL.ViewModel) {
        guard let url = URL(string: viewModel.displayedURL) else { return }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        title = viewModel.name
    }

}

// MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        setPlaceholder(status: .success)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        setPlaceholder(status: .failure)
    }
}
