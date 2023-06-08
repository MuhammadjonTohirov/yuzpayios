//
//  YTextFieldBackgroundModifier.swift
//  YuzPay
//
//  Created by applebro on 08/12/22.
//

import Foundation
import SwiftUI

struct YTextFieldBackgroundGrayStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
        .background {
            RoundedRectangle(cornerRadius: 12, style: .circular)
                .stroke(style: .init(lineWidth: 1))
                .foregroundColor(Color("gray_border"))
                .buttonBorderShape(.roundedRectangle)
        }
        .background(Color("gray_light"))
        .cornerRadius(12)
    }
}
