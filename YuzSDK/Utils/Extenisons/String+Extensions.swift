//
//  String+Extensions.swift
//  YuzSDK
//
//  Created by applebro on 28/04/23.
//

import Foundation

extension String: NetResBody {
    
}


public extension Encodable {
    /// Turns json into a Dictionary
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
    
    /// Turn json into a string
    var asString: String {
        guard let jsonData = try? JSONEncoder().encode(self) else {
            return ""
        }
        
        return String(data: jsonData, encoding: .utf8) ?? ""
    }
    
    func toJSONString(_ encoder: JSONEncoder = JSONEncoder()) throws -> NSString {
        let data = try encoder.encode(self)
        let result = String(decoding: data, as: UTF8.self)
        return NSString(string: result)
    }
    
    var asData: Data? {
        try? JSONEncoder().encode(self)
    }
}

public extension Substring {
    var asString: String {
        String(self)
    }
}

public extension String {
    
    var asInt: Int {
        Int(self) ?? 0
    }
    
    var isInt: Bool {
        Int(self) != nil
    }
    
    func localize(language: Language) -> String {
        let path = Bundle.main.path(forResource: language.code, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: self, comment: self)
    }
    
    var localize: String {
        return localize(language: UserSettings.shared.language ?? .russian)
    }

    func localize(arguments: CVarArg...) -> String {
        String.init(format: self.localize, arguments: arguments)
    }
    
    func onlyNumberFormat(with mask: String) -> String {
        let text = self
        let numbers = text.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        return numbers.format(with: mask)
    }
    
    func format(with mask: String) -> String {
        let text = self
        
        var result = ""
        var index = text.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < text.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(text[index])

                // move numbers iterator to the next index
                index = text.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
    
    var maskAsCardNumber: String {
        var text = self.replacingOccurrences(of: " ", with: "")
        if text.count < 16 {
            return ""
        }

        let replace = "••••••••"
        let range: Range<Index> = self.index(self.startIndex, offsetBy: 4)..<self.index(self.startIndex, offsetBy: 4 + replace.count)

        text = text.replacingCharacters(in: range, with: replace)
        
        return text.format(with: "XXXX XXXX XXXX XXXX")
    }
    
    var maskAsMiniCardNumber: String {
        var text = self.replacingOccurrences(of: " ", with: "")
        if text.count < 9 {
            return ""
        }
        text.removeFirst(text.count - 8)
        let replace = "••••"
        let range: Range<Index> = self.index(self.startIndex, offsetBy: 0)..<self.index(self.startIndex, offsetBy: replace.count)

        text = text.replacingCharacters(in: range, with: replace)
        
        return text.format(with: "XXXX XXXX")
    }
    
    var nilIfEmpty: String? {
        return self.isEmpty ? nil : self
    }
    
    var isNilOrEmpty: Bool {
        return self.nilIfEmpty == nil
    }
}

extension Bool: NetResBody {
    
}
