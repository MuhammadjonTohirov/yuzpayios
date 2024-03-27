//
//  YTextFieldBackgroundCleanStyle.swift
//  YuzPay
//
//  Created by applebro on 08/12/22.
//

import Foundation
import SwiftUI

struct YTextFieldBackgroundCleanStyle: ViewModifier {
    var padding: CGFloat = 2
    func body(content: Content) -> some View {
        content
            .padding(.leading, padding)
            .background {
                RoundedRectangle(cornerRadius: 12, style: .circular)
                    .stroke(style: .init(lineWidth: 2))
                    .foregroundColor(.secondaryLabel.opacity(0.5))
                    .buttonBorderShape(.roundedRectangle)
            }
            
            .background(Color("background"))
            .cornerRadius(12)
    }
}
