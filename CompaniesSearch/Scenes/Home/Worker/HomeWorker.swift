//
//  HomeWorker.swift
//  CompaniesSearch
//
//  Created by Vinicius Salmont on 11/01/21.
//

import UIKit

protocol HomeWorkerProtocol: class {
    func searchCompanies(query: String, success: @escaping ((CompaniesResponse) -> Void), failure: @escaping ((String) -> Void))
    func paginateCompanies(url: String, success: @escaping ((CompaniesResponse) -> Void), failure: @escaping ((String) -> Void))
}

class HomeWorker: HomeWorkerProtocol {
    func searchCompanies(query: String, success: @escaping ((CompaniesResponse) -> Void), failure: @escaping ((String) -> Void)) {
        NetworkService.shared.request(endpoint: HomeEndpoint.search(query: query), success: { (responseData) in
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(CompaniesResponse.self, from: responseData)
                success(data)
            } catch let error {
                failure(error.localizedDescription)
            }
        }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    func paginateCompanies(url: String, success: @escaping ((CompaniesResponse) -> Void), failure: @escaping ((String) -> Void)) {
        NetworkService.shared.request(endpoint: HomeEndpoint.paginate(url: url), success: { (responseData) in
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(CompaniesResponse.self, from: responseData)
                success(data)
            } catch let error {
                failure(error.localizedDescription)
            }
        }) { (error) in
            failure(error.localizedDescription)
        }
    }
}
