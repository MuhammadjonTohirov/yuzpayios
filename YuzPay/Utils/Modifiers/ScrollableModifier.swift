//
//  ScrollableModifier.swift
//  YuzPay
//
//  Created by applebro on 22/12/22.
//

import Foundation
import SwiftUI

struct ScrollableModifier: ViewModifier {
    var axis: Axis.Set
    var indicators: Bool
    
    func body(content: Content) -> some View {
        ScrollView(axis, showsIndicators: indicators) {
            content
        }
    }
}
