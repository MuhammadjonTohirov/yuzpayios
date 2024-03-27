//
//  UIScreen.swift
//  YuzPay
//
//  Created by applebro on 10/12/22.
//

import Foundation
import UIKit

extension UIScreen {
    static var screen: CGRect {
        return UIApplication.shared.firstKeyWindow?.screen.bounds ?? .zero
    }
}
