//
//  VIew+Extension.swift
//  YuzPay
//
//  Created by applebro on 22/12/22.
//

import Foundation
import SwiftUI

extension View {
    func scrollable(axis: Axis.Set = .vertical, showIndicators: Bool = false) -> some View {
        self.modifier(ScrollableModifier(axis: axis, indicators: showIndicators))
    }
}
