//
//  LocalRectReaderModifier.swift
//  YuzPay
//
//  Created by applebro on 08/12/22.
//

import Foundation
import SwiftUI

struct RectReader: ViewModifier  {
    @Binding var rect: CGRect
    
    func body(content: Content) -> some View {
        content.background(
            GeometryReader { geometry -> Color in
                let localFrame = geometry.frame(in: .global)
                DispatchQueue.main.async {
                    rect = localFrame
                    
                }
                return Color.clear
            }
        )
    }
}

extension View {
    func readSize(_ size: Binding<CGRect>) -> some View {
        self.modifier(RectReader(rect: size))
    }
}
