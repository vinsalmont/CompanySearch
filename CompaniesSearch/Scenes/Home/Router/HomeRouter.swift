//
//  HomeRouter.swift
//  CompaniesSearch
//
//  Created by Vinicius Salmont on 11/01/21.
//

import UIKit

protocol HomeRoutingLogic {
    func showWebview(url: String, name: String)
    func showNoURLAlert()
}

protocol HomeDataPassing {
    var dataStore: HomeDataStore? { get }
}

class HomeRouter: NSObject, HomeDataPassing, HomeRoutingLogic {
    weak var viewController: HomeViewController?
    var dataStore: HomeDataStore?

    func showNoURLAlert() {
        if let navigationController = viewController?.navigationController {
            let alert = UIAlertController(title: "Woops!", message: "This company do not have a login URL.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            navigationController.present(alert, animated: true, completion: nil)
        }
    }

    func showWebview(url: String, name: String) {
        if let navigationController = viewController?.navigationController {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let webViewController = storyboard.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController else { return }

            webViewController.router?.dataStore?.url = url
            webViewController.router?.dataStore?.name = name
            navigationController.present(webViewController, animated: true, completion: nil)
        }
    }
}
