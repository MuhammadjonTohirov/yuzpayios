//
//  String+Extensions.swift
//  YuzPay
//
//  Created by applebro on 11/12/22.
//

import Foundation

extension String {
    func localize(language: Language) -> String {
        let path = Bundle.main.path(forResource: language.code, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: self, comment: self)
    }
    
    public var localize: String {
        return localize(language: UserSettings.shared.language ?? .russian)
    }

    public func localize(arguments: CVarArg...) -> String {
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
        let range: Range<Index> = self.index(self.startIndex, offsetBy: 6)..<self.index(self.startIndex, offsetBy: 6 + replace.count)

        text = text.replacingCharacters(in: range, with: replace)
        
        return text.format(with: "XXXX XXXX XXXX XXXX")
    }
    
    var maskAsMiniCardNumber: String {
        var text = self.replacingOccurrences(of: " ", with: "")
        if text.count < 9 {
            return ""
        }
        text.removeFirst(text.count - 9)
        let replace = "••••"
        let range: Range<Index> = self.index(self.startIndex, offsetBy: 0)..<self.index(self.startIndex, offsetBy: replace.count)

        text = text.replacingCharacters(in: range, with: replace)
        
        return text.format(with: "XXXX XXXX")
    }
}
