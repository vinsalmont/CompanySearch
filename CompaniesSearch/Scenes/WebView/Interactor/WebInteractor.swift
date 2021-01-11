//
//  WebViewInteractor.swift
//  CompaniesSearch
//
//  Created by Vinicius Salmont on 11/01/21.
//
//

import UIKit

protocol WebViewBusinessLogic {
    func getURL()
}

protocol WebViewDataStore {
    var url: String? { get set }
    var name: String? { get set }
}

class WebViewInteractor: WebViewDataStore {
    var presenter: WebViewPresentationLogic?
    var url: String?
    var name: String?
}

// MARK: RepositoriesBusinessLogic
extension WebViewInteractor: WebViewBusinessLogic {
    func getURL() {
        guard let url = url,
              let name = name else { return }
        let response = WebViewModels.GetURL.Response(url: url, name: name)
        presenter?.presentURL(response: response)
    }
}
