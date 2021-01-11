//
//  CompaniesResponse.swift
//  CompaniesSearch
//
//  Created by Vinicius Salmont on 11/01/21.
//

import Foundation

struct CompaniesResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Company]
}

class Company: Codable, Identifiable {
    let id: String
    let name: String
    let longName: String?
    let type: String
    let category: String
    let isDisabled: Bool
    let loginURL: String?
    var completeLogoURL: String? {
        return  "https://res.cloudinary.com/argyle-media/image/upload/c_lfill,w_auto,g_auto,q_auto,dpr_auto,f_auto/v1566809938/partner-logos/\(name.lowercased()).png"
    }

    internal init(id: String, name: String, longName: String?, type: String, category: String, isDisabled: Bool, logoURL: String?, loginURL: String?) {
        self.id = id
        self.name = name
        self.longName = longName
        self.type = type
        self.category = category
        self.isDisabled = isDisabled
        self.loginURL = loginURL
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case longName = "long_name"
        case type
        case category
        case isDisabled = "is_disabled"
        case loginURL = "login_url"
    }
}
