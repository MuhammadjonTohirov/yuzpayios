//
//  Langugage.swift
//  YuzPay
//
//  Created by applebro on 11/12/22.
//

import Foundation

public enum Language: Int, Codable {
    case english = 0
    case russian
    case uzbek
    
    public static func language(_ code: String) -> Language {
        switch code {
        case "uz", "uz-UZ", "UZ":
            return .uzbek
        case "ru":
            return .russian
        case "en":
            return .english
        default:
            return .english
        }
    }
    
    public var name: String {
        switch self {
        case .uzbek:
            return "O'zbekcha"
        case .russian:
            return "Русский"
        case .english:
            return "English"
        }
    }

    public var code: String {
        switch self {
        case .uzbek:
            return "uz-UZ"

        case .russian:
            return "ru"

        case .english:
            return "en"
        }
    }
}
