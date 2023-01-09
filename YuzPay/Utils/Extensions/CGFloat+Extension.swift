//
//  CGFloat+Extension.swift
//  YuzPay
//
//  Created by applebro on 08/12/22.
//

import Foundation
import UIKit
import SwiftUI

extension CGFloat {
    static let designWidth: CGFloat = 420
    static let designHeight: CGFloat = 898
    
    func width(_ w: CGFloat, limit: CGFloat = 1.2) -> CGFloat {
        ((self / CGFloat.designWidth) * w).limitTop(self * limit)
    }
    
    func height(_ h: CGFloat, limit: CGFloat = 0.8) -> CGFloat {
        ((self / CGFloat.designHeight) * h).limitBottom(self * limit)
    }
    
    func sw(limit: CGFloat = 1.2) -> CGFloat {
        width(UIScreen.screen.width, limit: limit).limitBottom(self)
    }
    
    func sh(limit: CGFloat = 0.8) -> CGFloat {
        height(UIScreen.screen.height, limit: limit).limitTop(self)
    }
}
