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
}
