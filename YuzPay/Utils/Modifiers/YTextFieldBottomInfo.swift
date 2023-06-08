//
//  YTextFieldErrorStyle.swift
//  YuzPay
//
//  Created by applebro on 11/12/22.
//

import Foundation
import SwiftUI

struct YTextFieldBottomInfo: ViewModifier {
    var text: String
    var color: Color = Color("lite_blue")
    @State private var textOpacity: Double = 0
    
    func body(content: Content) -> some View {
        VStack(alignment: .trailing, spacing: 4) {
            content
            Text(text)
                .font(.mont(.medium, size: 12))
                .foregroundColor(color)
                .opacity(textOpacity)
        }.onAppear {
            withAnimation(.easeIn(duration: 0.2)) {
                textOpacity = text.isEmpty ? 0 : 1
            }
        }
    }
}
