//
//  UIApplication+Extensions.swift
//  YuzPay
//
//  Created by applebro on 22/12/22.
//

import Foundation
import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    var safeArea: UIEdgeInsets {
        connectedScenes.first(where: {$0.activationState == .foregroundActive}).flatMap({$0 as? UIWindowScene})?.windows.first(where: {$0.isKeyWindow})?.safeAreaInsets ?? .zero
    }
}
