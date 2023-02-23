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
        }
    }
    
    var body: Data? {
        return nil
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    func request() -> URLRequest {
        var request = URLRequest.new(url: self.url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        return request
    }
    
    case getCategories
    case getMerchants(byCategory: Int, limit: Int?)
}
