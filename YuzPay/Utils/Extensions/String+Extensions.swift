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
}
