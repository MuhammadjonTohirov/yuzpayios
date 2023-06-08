//
//  UINavigationController+Extensions.swift
//  YuzPay
//
//  Created by applebro on 22/12/22.
//

import Foundation
import UIKit

extension UINavigationController {
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationBar.topItem?.backButtonDisplayMode = .minimal
    }
}
