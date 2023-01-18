//
//  Color+Extensions.swift
//  YuzPay
//
//  Created by applebro on 17/01/23.
//

import Foundation
import SwiftUI
import UIKit

extension UIColor {
    static var label: UIColor {
        UIColor(named: "label_color")!
    }
    
    static var secondaryLabel: UIColor {
        UIColor(named: "label_color_secondary")!
    }
    
    static var accent: UIColor {
        UIColor(named: "accent")!
    }
    
    static var accentLight: UIColor {
        UIColor(named: "accent_light")!
    }
    
    static var background: UIColor {
        .systemBackground
    }
    
    static var lightGray: UIColor {
        UIColor(named: "dark_gray")!
    }
    
    static var appGray: UIColor {
        UIColor(named: "gray")!
    }
    
    static var appDarkGray: UIColor {
        UIColor(named: "dark_gray")!
    }
    
    static var appLightGray: UIColor {
        UIColor(named: "gray_light")!
    }
}
