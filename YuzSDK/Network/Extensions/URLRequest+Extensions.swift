//
//  URL+Request.swift
//  YuzPay
//
//  Created by applebro on 15/02/23.
//

import Foundation

extension URLRequest {
    
    /// This method helps to create a urlrequest object with headers related to this application
    static func new(url: URL, policy: CachePolicy = .useProtocolCachePolicy, withAuth: Bool = true, interval: TimeInterval = 60.0) -> URLRequest {
        var req = URLRequest(url: url, cachePolicy: policy, timeoutInterval: interval)
        req.addValue(URL.keyHeader.value, forHTTPHeaderField: URL.keyHeader.key)
        req.addValue(URL.langHeader.value, forHTTPHeaderField: URL.langHeader.key)
        req.addValue("IOS", forHTTPHeaderField: "X-DEVICE-TYPE")
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.addValue("application/json", forHTTPHeaderField: "accept")
        
        if let accessToken = UserSettings.shared.accessToken, withAuth {
            req.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        return req
    }
    
    static func fromDataRequest(url: URL, boundary: String, policy: CachePolicy = .useProtocolCachePolicy, interval: TimeInterval = 60.0, withAuth: Bool = true) -> URLRequest {
        var req = URLRequest(url: url, cachePolicy: policy, timeoutInterval: interval)
        req.addValue(URL.keyHeader.value, forHTTPHeaderField: URL.keyHeader.key)
        req.addValue(URL.langHeader.value, forHTTPHeaderField: URL.langHeader.key)
        req.addValue("IOS", forHTTPHeaderField: "X-DEVICE-TYPE")
        req.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        req.addValue("application/json", forHTTPHeaderField: "accept")
        
        if let accessToken = UserSettings.shared.accessToken, withAuth {
            req.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        return req
    }
}
