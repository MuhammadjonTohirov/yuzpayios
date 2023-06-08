//
//  TopLeftDismissModifier.swift
//  YuzPay
//
//  Created by applebro on 19/12/22.
//

import Foundation
import SwiftUI

struct TopLeftDismissModifier: ViewModifier {
    @Environment(\.dismiss) var dismiss
    var onDismiss: (() -> Void)? = nil
    func body(content: Content) -> some View {
        ZStack {
            Button {
                dismiss()
                onDismiss?()
            } label: {
                Image("icon_x")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .fixedSize()
            }
            .zIndex(1)
            .frame(width: 20, height: 20)
            .position(x: 40, y: 20)
            
            content
        }
    }
}
