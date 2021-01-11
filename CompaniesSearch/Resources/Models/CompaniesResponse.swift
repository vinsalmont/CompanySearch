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
        return  "https://res.cloudinary.com/argyle-media/image/upload/c_lfill,w_auto,g_auto,q_auto,dpr_auto,f_auto/v1566809938/partner-logos/\(name).png"
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

#if DEBUG
let testData = CompaniesResponse(count: 10, next: nil, previous: nil, results: [
    Company(id: "321", name: "Uber", longName: "Uber Rider", type: "company", category: "rider company", isDisabled: false, logoURL: "https://images.ctfassets.net/37l920h5or7f/1VR43iWEPnMkLPWY7QoI8T/ad3c0a10d67a9861d86fc3abbe341132/Uber-Asset-Logo-34.jpg?fm=jpg&q=70&w=1600", loginURL: "http://partners.uber.com/"),
    Company(id: "23213", name: "Argyle", longName: "Argyle", type: "company", category: "product company", isDisabled: false, logoURL: "https://res-3.cloudinary.com/crunchbase-production/image/upload/c_lpad,f_auto,q_auto:eco/mvijdq2ulwhy0f0zu97m", loginURL: "https://argyle.com/"),

    Company(id: "412", name: "Test", longName: "Test company", type: "company", category: "test company", isDisabled: false, logoURL: nil, loginURL: nil)

])
#endif
