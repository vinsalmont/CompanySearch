//
//  WebPresenter.swift
//  CompaniesSearch
//
//  Created by Vinicius Salmont on 11/01/21.
//

import UIKit

protocol WebViewPresentationLogic {
    func presentURL(response: WebViewModels.GetURL.Response)
}

class WebViewPresenter: WebViewPresentationLogic {
    weak var viewController: WebDisplayLogic?

    func presentURL(response: WebViewModels.GetURL.Response) {
        let viewModel = WebViewModels.GetURL.ViewModel(displayedURL: response.url, name: response.name)
        viewController?.showWebView(viewModel: viewModel)
    }
}
