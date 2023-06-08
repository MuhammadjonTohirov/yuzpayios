//
//  UIFont+Extension.swift
//  YuzPay
//
//  Created by applebro on 08/12/22.
//

import Foundation
import UIKit
import SwiftUI

public extension UIFont {
    enum MontSerrat: String {
        case black = "Black"
        case blackItalic = "BlackItalic"
        case bold = "Bold"
        case boldItalic = "BoldItalic"
        case extraBold = "ExtraBold"
        case extraBoldItalic = "ExtraBoldItalic"
        case extraLight = "ExtraLight"
        case extraLightItalic = "ExtraLightItalic"
        case italic = "Italic"
        case light = "Light"
        case lightItalic = "LightItalic"
        case medium = "Medium"
        case mediumItalic = "MediumItalic"
        case regular = "Regular"
        case semibold = "SemiBold"
        case semiboldItalic = "SemiBoldItalic"
        case thin = "Thin"
        case thinItalic = "ThinItalic"
    }
    
    static func mont(_ type: MontSerrat, size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-\(type.rawValue)", size: size) ?? .systemFont(ofSize: size)
    }
}

public extension Font {
    static func mont(_ type: UIFont.MontSerrat, size: CGFloat) -> Font {
        return Font(UIFont(name: "Montserrat-\(type.rawValue)", size: size.sh(limit: 0.5)) ?? .systemFont(ofSize: size))
    }
}
