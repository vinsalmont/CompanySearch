//
//  WebViewModels.swift
//  CompaniesSearch
//
//  Created by Vinicius Salmont on 11/01/21.
//

import UIKit

enum WebViewModels {
    enum GetURL {
        struct Response {
            var url: String
            var name: String
        }

        struct ViewModel {
            var displayedURL: String
            var name: String
        }
    }
}

