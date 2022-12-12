//
//  YTextFieldBackgroundCleanStyle.swift
//  YuzPay
//
//  Created by applebro on 08/12/22.
//

import Foundation
import SwiftUI

struct YTextFieldBackgroundCleanStyle: ViewModifier {
    var padding: CGFloat = 0
    func body(content: Content) -> some View {
        content
            .padding(.leading, padding)
            .background {
                RoundedRectangle(cornerRadius: 12, style: .circular)
                    .stroke(style: .init(lineWidth: 1))
                    .foregroundColor(Color("dark_gray"))
                    .buttonBorderShape(.roundedRectangle)
            }
            
            .background(Color("background"))
            .cornerRadius(12)
    }
}
