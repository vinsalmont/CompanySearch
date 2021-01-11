//
//  NetworkService.swift
//  CompaniesSearch
//
//  Created by Vinicius Salmont on 11/01/21.
//

import Alamofire

protocol Endpoint {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
    var header: HTTPHeaders? { get }
    var encoding: ParameterEncoding { get }
}

class NetworkService {
    static let shared = NetworkService()
    private var dataRequest: DataRequest?
    private var success: ((_ data: Data?) -> Void)?
    private var failure: ((_ error: Error?) -> Void)?

    @discardableResult
    private func dataRequest(url: URLConvertible,
                             method: HTTPMethod,
                             parameters: Parameters? = nil,
                             encoding: ParameterEncoding,
                             headers: HTTPHeaders? = nil) -> DataRequest {
        return SessionManager.default.request(url,
                                              method: method,
                                              encoding: encoding,
                                              headers: headers)
    }

    func request<T: Endpoint>(endpoint: T,
                              success: ((_ data: Data) -> Void)? = nil,
                              failure: ((_ error: Error) -> Void)? = nil) {
        self.dataRequest = self.dataRequest(url: endpoint.path,
                                            method: endpoint.method,
                                            parameters: endpoint.parameters,
                                            encoding: endpoint.encoding,
                                            headers: endpoint.header)
        self.dataRequest?.responseData(completionHandler: { (response) in
            switch response.result {
            case let .success(data):
                success?(data)
            case let .failure(error):
                failure?(error)
            }
        })
    }
}
