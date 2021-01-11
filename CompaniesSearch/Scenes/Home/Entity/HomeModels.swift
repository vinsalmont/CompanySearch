//
//  HomeModels.swift
//  CompaniesSearch
//
//  Created by Vinicius Salmont on 11/01/21.
//

import UIKit

enum HomeModels {
    enum FetchCompanies {
        struct Search {
            var query: String
        }

        struct Paginate {
            var url: String
        }

        struct Response {
            var items: [Company]
            var nextUrl: String?
            var previousUrl: String?
        }

        struct Error {
            var message: String
        }

        struct ViewModel {
            struct DisplayedCompany {
                var id: String
                var name: String
                var longName: String?
                var type: String
                var category: String
                var isDisabled: Bool
                var logoURL: String?
                var loginURL: String?
            }

            var displayedCompanies: [DisplayedCompany]
            var nextUrl: String?
            var previousUrl: String?
        }
    }
}
