//
//  NetworkService.swift
//  YuzPay
//
//  Created by applebro on 15/02/23.
//

import Foundation

struct Network {
    
    static func send<T: NetResBody>(request: URLRequestProtocol) async -> NetRes<T>? {
        Logging.l("--- --- REQUEST --- ---")
        Logging.l(request.url.absoluteString)
        
        if let requestBody = request.request().httpBody, let json = try? JSONSerialization.jsonObject(with: requestBody, options: .fragmentsAllowed) as? [String: Any] {
            Logging.l(json)
        }
        
        let result = try? await URLSession.shared.data(for: request.request())
        
        guard let data = result?.0 else {
            return nil
        }
        
        guard let res = try? JSONDecoder().decode(NetRes<T>.self, from: data) else {
            return nil
        }
        
        Logging.l("--- --- RESPONSE --- ---")
        Logging.l(res.asString)
        
        return res
    }
    
    static func upload<T: NetResBody>(body: T.Type, request: URLRequestProtocol, completion: @escaping (NetRes<T>?) -> Void) {
        Logging.l("--- --- REQUEST --- ---")
        Logging.l(request.url.absoluteString)
        
        if let requestBody = request.request().httpBody, let json = try? JSONSerialization.jsonObject(with: requestBody, options: .fragmentsAllowed) as? [String: Any] {
            Logging.l(json)
        }
        
        URLSession.shared.uploadTask(with: request.request(), from: request.body) { data, _, _ in
            guard let data = data, let res = try? JSONDecoder().decode(NetRes<T>.self, from: data) else {
                completion(nil)
                return
            }

            
            Logging.l("--- --- RESPONSE --- ---")
            Logging.l(res.asString)

            completion(res)
        }.resume()
    }
}

class NetUploadHandler: NSObject, URLSessionDataDelegate {
    var onFinishUpload: (_ data: Data?) -> Void
    
    init(onFinishUpload: @escaping (_: Data?) -> Void) {
        self.onFinishUpload = onFinishUpload
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        onFinishUpload(data)
    }
}

