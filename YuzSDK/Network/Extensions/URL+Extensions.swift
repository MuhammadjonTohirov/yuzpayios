//
//  URL+Extensions.swift
//  YuzPay
//
//  Created by applebro on 11/02/23.
//

import Foundation
import UniformTypeIdentifiers

public extension URL {
    
    static var base: URL {
        .init(string: "https://api.yuzpay.uz")!//http://95.47.127.26:50000/
    }
    
    static var keyHeader: (key: String, value: String) {
        ("X-APP-SERIAL", "14839cb365cd8b8dfdf083932457015c63ae5db23d503db80d14ee4916a9436a")
    }
    
    static var langHeader: (key: String, value: String) {
        ("X-LANG-CODE", (UserSettings.shared.language ?? .russian).smallCode)
    }
    
    static let yuzpayURL: URL = URL.init(string: "https://yuzpay.uz/")!
    
    static let tadiURL: URL = URL.init(string: "https://tadi.uz/")!
    
    static let telegramBotURL: URL = URL.init(string: "https://t.me/yuzpaybot")!
    
    func appendingPath(_ pathList: Any...) -> URL {
        var url = self
        pathList.forEach { path in
            if #available(iOS 16.0, *) {
                url = url.appending(component: "\(path)")
            } else {
                url = url.appendingPathComponent("\(path)")
            }
        }
        
        return url
    }
    
    var fileSize: UInt64 {
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }
    
    var attributes: [FileAttributeKey : Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch {
            
        }
        return nil
    }
    
    var exists: Bool {
        FileManager.default.fileExists(atPath: self.path)
    }
    
    var fileSizeBeautifiedString: String {
        return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
    }
    
    var mimeType: String {
        mimeTypeForPath(pathExtension: self.pathExtension)
    }

    private func mimeTypeForPath(pathExtension: String) -> String {
        return UTType(filenameExtension: pathExtension)?.preferredMIMEType ?? ""
    }
    
    func queries(_ queries: URLQueryItem...) -> URL {
        var components = URLComponents(string: self.absoluteString)
        components?.queryItems = Array(queries)
        return components?.url ?? self
    }
}

extension Language {
    fileprivate var smallCode: String {
        switch self {
        case .uzbek:
            return "uz"

        case .russian:
            return "ru"

        case .english:
            return "en"
        }
    }
}
