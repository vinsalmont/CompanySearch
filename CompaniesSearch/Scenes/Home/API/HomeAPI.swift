//
//  HomeAPI.swift
//  CompaniesSearch
//
//  Created by Vinicius Salmont on 11/01/21.
//

import Alamofire

enum HomeEndpoint {
    case search(query: String)
    case paginate(url: String)
}

extension HomeEndpoint: Endpoint {
    var method: HTTPMethod {
        return .get
    }

    var path: String {
        switch self {
        case let .search(query):
            return "\(Constants.baseURL)/link-items?limit=15&offset=0&search=\(query)"
        case let .paginate(url):
            return url
        }
    }

    var parameters: Parameters? {
        return nil
    }

    var header: HTTPHeaders? {
        return nil
    }

    var encoding: ParameterEncoding {
        return URLEncoding(destination: .queryString)
    }
}
