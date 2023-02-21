//
//  URL+Extensions.swift
//  YuzPay
//
//  Created by applebro on 11/02/23.
//

import Foundation
import UniformTypeIdentifiers

extension URL {
    
    static var base: URL {
        .init(string: "http://95.47.127.26:50000")!//http://95.47.127.26:50000/
    }
    
    static var keyHeader: (key: String, value: String) {
        ("X-APP-SERIAL", "8037297dcfd1fc6ca42dee7001111a0111f9fea4002b4441d78f8176286293df")
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