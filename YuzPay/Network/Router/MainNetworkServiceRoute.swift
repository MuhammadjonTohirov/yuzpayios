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
            return URL.base.appendingPath("api", "Client", "PaymentCategoryList")
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
}
