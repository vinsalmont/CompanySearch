    //
    //  HomeInteractor.swift
    //  CompaniesSearch
    //
    //  Created by Vinicius Salmont on 11/01/21.
    //

    import Foundation

    protocol HomeBusinessLogic: class {
        func searchCompanies(request: HomeModels.FetchCompanies.Search)
        func paginateCompanies(request: HomeModels.FetchCompanies.Paginate)
    }

    protocol HomeDataStore {
        var companies: [Company]? { get set }
    }

    class HomeInteractor: HomeDataStore, HomeBusinessLogic {
        var presenter: HomePresentationLogic?
        var worker = HomeWorker()
        var companies: [Company]?

        func searchCompanies(request: HomeModels.FetchCompanies.Search) {
            worker.searchCompanies(query: request.query) { (response) in
                let homeResponse = HomeModels.FetchCompanies.Response(items: response.results, nextUrl: response.next, previousUrl: response.previous)
                self.companies = response.results

                self.presenter?.presentCompanies(response: homeResponse)
            } failure: { (error) in
                self.companies = []

                let homeError = HomeModels.FetchCompanies.Error(message: error)

                self.presenter?.presentError(error: homeError)
            }

        }

        func paginateCompanies(request: HomeModels.FetchCompanies.Paginate) {
            worker.paginateCompanies(url: request.url) { (response) in
                let homeResponse = HomeModels.FetchCompanies.Response(items: response.results, nextUrl: response.next, previousUrl: response.previous)
                self.companies = response.results

                self.presenter?.presentCompanies(response: homeResponse)
            } failure: { (error) in
                self.companies = []

                let homeError = HomeModels.FetchCompanies.Error(message: error)

                self.presenter?.presentError(error: homeError)

            }

        }
    }
