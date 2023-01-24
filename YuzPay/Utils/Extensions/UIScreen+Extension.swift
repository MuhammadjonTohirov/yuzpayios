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
        return UIApplication.shared.connectedScenes.first(where: {$0.activationState == .foregroundActive}).flatMap({$0 as? UIWindowScene})?.windows.first(where: {$0.isKeyWindow})?.bounds ?? .zero
    }
}
