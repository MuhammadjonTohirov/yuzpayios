//
//  UIView+Extensions.swift
//  YuzPay
//
//  Created by applebro on 27/12/22.
//

import Foundation
import UIKit

extension UIView {
    func onClick(_ target: Any?, _ selector: Selector) {
        let gesture = UITapGestureRecognizer(target: target, action: selector)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(gesture)
    }
}
