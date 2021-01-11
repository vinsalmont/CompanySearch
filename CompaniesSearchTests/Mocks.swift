//
//  Mocks.swift
//  CompaniesSearchTests
//
//  Created by Vinicius Salmont on 11/01/21.
//

@testable import CompaniesSearch
import XCTest

struct Mocks {
   static let companiesResponsModel = CompaniesResponse(count: 10, next: "https://www.google.com", previous: "https://www.google.com", results: [
        Company(id: "321", name: "Uber", longName: "Uber Rider", type: "company", category: "rider company", isDisabled: false, logoURL: "https://res.cloudinary.com/argyle-media/image/upload/c_lfill,w_auto,g_auto,q_auto,dpr_auto,f_auto/v1566809938/partner-logos/uber.png", loginURL: "http://partners.uber.com/")
    ])

    static let referenceModel = Company(id: "321", name: "Uber", longName: "Uber Rider", type: "company", category: "rider company", isDisabled: false, logoURL: "https://res.cloudinary.com/argyle-media/image/upload/c_lfill,w_auto,g_auto,q_auto,dpr_auto,f_auto/v1566809938/partner-logos/uber.png", loginURL: "http://partners.uber.com/")

    static let displayedCompany = HomeModels.FetchCompanies.ViewModel.DisplayedCompany(id: referenceModel.id, name: referenceModel.name, longName: referenceModel.longName, type: referenceModel.type, category: referenceModel.category, isDisabled: referenceModel.isDisabled, logoURL: referenceModel.completeLogoURL, loginURL: referenceModel.loginURL)

    static let displayedURL = WebViewModels.GetURL.ViewModel(displayedURL: referenceModel.loginURL ?? "", name: referenceModel.name)
}
