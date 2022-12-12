//
//  PinCodeView.swift
//  YuzPay
//
//  Created by applebro on 09/12/22.
//

import Foundation
import SwiftUI


struct PinCodeView: View {
    @ObservedObject var viewModel = PinCodeViewModel()
    
    let keyboardHeight: CGFloat = 288.f.sh(limit: 0.2)
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Text(viewModel.title)
                .font(.mont(.extraBold, size: 32))
                .foregroundColor(Color("accent_light"))

            Spacer()

            HStack {
                ForEach(0..<viewModel.maxCharacters, id: \.self) { id in
                    pinItem(id)
                }
            }
            .foregroundColor(Color("gray"))
            .padding(Padding.default)
            
            KeyboardView(text: $viewModel.pin, maxCharacters: viewModel.maxCharacters)
                .onChange(of: viewModel.pin) { newValue in
                    if newValue.count == viewModel.maxCharacters {
                        viewModel.onEditingPin()
                    }
                }
            
            HoverButton(title: "Далее", backgroundColor: Color("accent_light_2"), titleColor: .white, isEnabled: viewModel.isConfirmed) {
                
            }
            .padding(Padding.default)
        }
        .multilineTextAlignment(.center)
    }
    
    func pinItem(_ id: Int) -> some View {
        Circle()
            .frame(width: 16.f.sh(limit: 0.2))
            .foregroundColor(id >= viewModel.pin.count ? Color("gray") : Color("accent_light_2"))
    }
}

struct PinCodeView_Preview: PreviewProvider {
    static var previews: some View {
        PinCodeView()
    }
}
