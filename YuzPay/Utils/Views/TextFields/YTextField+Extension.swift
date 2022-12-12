//
//  YTextField+Extension.swift
//  YuzPay
//
//  Created by applebro on 08/12/22.
//

import Foundation
import SwiftUI

extension View {
    func placeholder(
        _ text: String,
        when shouldShow: Bool,
        alignment: Alignment = .leading, color: Color = Color("accent").opacity(0.47)) -> some View {
            
            placeholder(when: shouldShow, alignment: alignment) { Text(text).foregroundColor(color) }
        }
    
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}

extension YTextField {
    func keyboardType(_ type: UIKeyboardType) -> YTextField {
        var view = self
        view.keyboardType = type
        return view
    }
    
    func set(height: CGFloat) -> YTextField {
        var view = self
        view.height = height
        return view
    }
    
    func set(haveTitle: Bool) -> YTextField {
        var view = self
        view.haveTitle = haveTitle
        return view
    }
}
