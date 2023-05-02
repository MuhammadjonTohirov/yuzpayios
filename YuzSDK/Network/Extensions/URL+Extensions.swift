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
        .init(string: "http://95.47.127.26:50000")!//http://95.47.127.26:50000/
    }
    
    static var keyHeader: (key: String, value: String) {
        ("X-APP-SERIAL", "f0d0b4a09aeaf5bdc826079f5b8b439a7cbad7318896b22f0c3811d3f3c7fb49")
    }
    
    static var langHeader: (key: String, value: String) {
        ("X-LANG-CODE", (UserSettings.shared.language ?? .russian).smallCode)
    }
    
    func appendingPath(_ pathList: String...) -> URL {
        var url = self
        pathList.forEach { path in
            if #available(iOS 16.0, *) {
                url = url.appending(component: path)
            } else {
                url = url.appendingPathComponent(path)
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
