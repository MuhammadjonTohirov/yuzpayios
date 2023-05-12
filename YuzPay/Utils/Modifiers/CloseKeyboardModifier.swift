//
//  CloseKeyboardModifier.swift
//  YuzPay
//
//  Created by applebro on 12/05/23.
//

import SwiftUI

struct CloseKeyboardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Text("")
                }
                
                ToolbarItem(placement: .keyboard) {
                    Button {
                        UIApplication.shared.endEditing()
                    } label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                }
            }
    }
}
