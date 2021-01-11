//
//  WebRouter.swift
//  CompaniesSearch
//
//  Created by Vinicius Salmont on 11/01/21.
//

import UIKit

protocol WebViewDataPassing {
    var dataStore: WebViewDataStore? { get set }
}

class WebViewRouter: NSObject, WebViewDataPassing {
    weak var viewController: WebViewController?
    var dataStore: WebViewDataStore?
}
