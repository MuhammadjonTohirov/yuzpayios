//
//  UIApplication+Extensions.swift
//  YuzPay
//
//  Created by applebro on 22/12/22.
//

import Swift
import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    var safeArea: UIEdgeInsets {
        connectedScenes.first(where: {$0.activationState == .foregroundActive}).flatMap({$0 as? UIWindowScene})?.windows.first(where: {$0.isKeyWindow})?.safeAreaInsets ?? .zero
    }
}

#if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst)

extension UIApplication {
    public var firstKeyWindow: UIWindow? {
        windows.first(where: { $0.isKeyWindow })
    }
}

#endif
