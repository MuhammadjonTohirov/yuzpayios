//
//  MainNetworkServiceRoute.swift
//  YuzPay
//
//  Created by applebro on 21/02/23.
//

import Foundation

enum MainNetworkServiceRoute: URLRequestProtocol {
    var url: URL {
        switch self {
        case .getCategories:
            return URL.base.appendingPath("api", "Client", "PaynetCategoryList")
        case let .getMerchants(cat, limit):
            if let l = limit {
                let url = URL.base.appendingPath("api", "Client", "PaynetProviderList", "\(cat)").queries(.init(name: "topRecords", value: "\(l)"))
                return url
            }
            return URL.base.appendingPath("api", "Client", "PaynetProviderList", "\(cat)")
        case let .searchMerchants(text, limit):
            return URL.base.appendingPath("api", "Client", "PaynetSearchProviders").queries(
                .init(name: "topRecords", value: "\(limit ?? 20)"),
                .init(name: "searchTerm", value: text)
            )
        case .getInvoiceList:
            return URL.base.appendingPath("api", "Client", "InvoiceList")
        }
    }
    
    var body: Data? {
        return nil
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchMerchants:
            return .post
        default:
            return .get
        }
    }
    
    func request() -> URLRequest {
        var request = URLRequest.new(url: self.url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        return request
    }
    
    case getCategories
    case getMerchants(byCategory: Int, limit: Int?)
    case searchMerchants(text: String, limit: Int?)
    case getInvoiceList
}
