//
//  PinCodeView.swift
//  YuzPay
//
//  Created by applebro on 09/12/22.
//

import Foundation
import SwiftUI


struct PinCodeView: View {
    @ObservedObject var viewModel = PinCodeViewModel(title: "setup_pin".localize, reason: .confirm(pin: "12"))
    
    let keyboardHeight: CGFloat = 288.f.sh(limit: 0.2)
    
    @ViewBuilder var body: some View {
        innerBody
            .set(hasDismiss: viewModel.reason.id == PinViewReason.confirm(pin: "").id)
    }
    
    var innerBody: some View {
        VStack(spacing: 0) {
            Spacer()
            Text(viewModel.title)
                .font(.mont(.extraBold, size: 32))
                .foregroundColor(Color("accent_light"))

            Spacer()

            HStack(spacing: Padding.medium) {
                ForEach(0..<viewModel.maxCharacters, id: \.self) { id in
                    pinItem(id)
                }
            }
            .foregroundColor(Color("gray"))
            .padding(Padding.large * 2)
            
            KeyboardView(text: $viewModel.pin, viewModel: viewModel.keyboardModel) {
                if viewModel.reason == .login {
                    UserSettings.shared.appPin = nil
                    mainRouter?.navigate(to: .auth)
                }
            }
            .onChange(of: viewModel.pin) { newValue in
                if newValue.count == viewModel.maxCharacters {
                    viewModel.onEditingPin()
                }
            }
            
            if viewModel.reason != .login {
                HoverButton(title: "Далее", backgroundColor: Color("accent_light_2"), titleColor: .white, isEnabled: viewModel.isButtonEnabled) {
                    viewModel.onClickNext()
                }
                .padding(Padding.default)
            }
        }
        .multilineTextAlignment(.center)
        .fullScreenCover(unwrapping: $viewModel.route) { dest in
            dest.wrappedValue.screen
        }
    }
    
    func pinItem(_ id: Int) -> some View {
        Circle()
            .frame(width: 20.f.sh(limit: 0.2))
            .foregroundColor(id >= viewModel.pin.count ? Color("gray") : Color("accent_light_2"))
    }
}

struct PinCodeView_Preview: PreviewProvider {
    static var previews: some View {
        PinCodeView(viewModel: PinCodeViewModel(title: "enter_pin".localize, reason: .login))
    }
}

extension View {
    @ViewBuilder func set(hasDismiss: Bool) -> some View {
        if hasDismiss {
            self.modifier(TopLeftDismissModifier())
        } else {
            self
        }
    }
}
