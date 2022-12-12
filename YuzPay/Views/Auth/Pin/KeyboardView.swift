//
//  KeyboardView.swift
//  YuzPay
//
//  Created by applebro on 10/12/22.
//

import Foundation
import SwiftUI

struct KeyboardView: View {
    let keyboardHeight: CGFloat = 288.f.sh(limit: 0.2)
    
    @Binding var text: String
    
    /// 0 or negative means unlimited
    var maxCharacters: Int = 4
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                keyboard(proxy)
                keyboardDividers(proxy)
                    .foregroundColor(Color("gray"))
            }
        }
        .frame(height: keyboardHeight)
    }
    
    @ViewBuilder func keyboardDividers(_ proxy: GeometryProxy) -> some View {
        Rectangle()
            .frame(width: 1, height: keyboardHeight)
            .position(
                x: proxy.frame(in: .local).width / 3,
                y: proxy.frame(in: .local).height / 2
            )
        
        Rectangle()
            .frame(width: 1, height: keyboardHeight)
            .position(
                x: 2 * proxy.frame(in: .local).width / 3,
                y: keyboardHeight / 2
            )

        Rectangle()
            .frame(width: proxy.frame(in: .local).width, height: 1)
            .position(
                x: proxy.frame(in: .local).width / 2,
                y: keyboardHeight / 4
            )
        
        Rectangle()
            .frame(width: proxy.frame(in: .local).width, height: 1)
            .position(
                x: proxy.frame(in: .local).width / 2,
                y: 2 * keyboardHeight / 4
            )
        
        Rectangle()
            .frame(width: proxy.frame(in: .local).width, height: 1)
            .position(
                x: proxy.frame(in: .local).width / 2,
                y: 3 * keyboardHeight / 4
            )
    }
    
    func keyboard(_ proxy: GeometryProxy) -> some View {
        LazyVGrid(columns: [
            GridItem(),
            GridItem(),
            GridItem()
        ], spacing: 48.f.sh(limit: 0.2)) {
            keyboardFirstRow
            keyboardSecondRow
            keyboardThirdRow
            keyItem(.clear)
            keyItem(.zero)
            keyItem(.backSpace)
        }
        .font(.mont(.semibold, size: 24))
    }
    
    @ViewBuilder var keyboardFirstRow: some View {
        keyItem(.one)
        keyItem(.two)
        keyItem(.three)
    }
    
    @ViewBuilder var keyboardSecondRow: some View {
        keyItem(.four)
        keyItem(.five)
        keyItem(.six)
    }
    
    @ViewBuilder var keyboardThirdRow: some View {
        keyItem(.seven)
        keyItem(.eight)
        keyItem(.nine)
    }
    
    func keyItem(_ val: Key) -> some View {
        Button {
            switch val {
            case .clear:
                text = ""
            case .backSpace:
                _ = text.popLast()
            default:
                if maxCharacters <= 0 {
                    text.append("\(val.rawValue)")
                    return
                }
                
                if text.count < maxCharacters {
                    text.append("\(val.rawValue)")
                    return
                }
            }
        } label: {
            val.view
                .frame(width: 92.f.sh(limit: 0.2), height: 24.f.sh(limit: 0.2))
                .foregroundColor(Color("dark_gray"))
        }
    }
}

struct KeyboardView_Preview: PreviewProvider {
    @State static var text: String = ""
    static var previews: some View {
        KeyboardView(text: $text)
    }
}

