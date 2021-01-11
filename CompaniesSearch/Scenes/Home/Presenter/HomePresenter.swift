//
//  HomePresenter.swift
//  CompaniesSearch
//
//  Created by Vinicius Salmont on 11/01/21.
//

import UIKit

protocol HomePresentationLogic {
    func presentError(error: HomeModels.FetchCompanies.Error)
    func presentCompanies(response: HomeModels.FetchCompanies.Response)
}

class HomePresenter: HomePresentationLogic {
    weak var viewController: HomeDisplayLogic?

    func presentError(error: HomeModels.FetchCompanies.Error) {
        viewController?.showError(message: error.message)
    }

    func presentCompanies(response: HomeModels.FetchCompanies.Response) {
        let displayedCompanies = response.items.map {
            HomeModels.FetchCompanies.ViewModel.DisplayedCompany(
                id: $0.id,
                name: $0.name,
                longName: $0.longName,
                type: $0.type,
                category: $0.category,
                isDisabled: $0.isDisabled,
                logoURL: $0.completeLogoURL,
                loginURL: $0.loginURL
            )
        }

        let viewModel = HomeModels.FetchCompanies.ViewModel(displayedCompanies: displayedCompanies, nextUrl: response.nextUrl, previousUrl: response.previousUrl)
        viewController?.showCompanies(viewModel: viewModel)
    }
}
