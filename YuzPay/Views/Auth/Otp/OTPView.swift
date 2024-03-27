//
//  OTPView.swift
//  YuzPay
//
//  Created by applebro on 11/12/22.
//

import Foundation
import SwiftUI

struct OTPView: View {
    @ObservedObject var viewModel: OtpViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        innerBody
            .modifier(TopLeftDismissModifier())
    }
    
    var innerBody: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 36) {
                Text(viewModel.title)
                    .font(.mont(.extraBold, size: 32))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("accent_light"))

                Text("otp_sent_to_number".localize(arguments: viewModel.number)) { str in
                    if let range = str.range(of: viewModel.number) {
                        str[range].font = UIFont.mont(.medium, size: 14)

                    }
                }
                .font(.mont(.regular, size: 14))
                .multilineTextAlignment(.center)
                .padding(.horizontal, Padding.medium)
                
                YTextField(text: $viewModel.otp, placeholder: "Код подтверждения", contentType: .oneTimeCode, right: {
                    HStack {
                        Rectangle()
                            .frame(width: 0.5, height: 44)
                            .foregroundColor(Color("gray"))
                            .padding(.trailing, 4)
                        Text(viewModel.counter)
                            .foregroundColor(Color("accent_light"))
                    }
                    .padding(.trailing, 12)
                })
                .keyboardType(.numberPad)
                .onChange(of: viewModel.otp, perform: { _ in
                    self.viewModel.onTypingOtp()
                })
                .modifier(YTextFieldBackgroundCleanStyle(padding: Padding.default))
                .modifier(YTextFieldBottomInfo(text: viewModel.otpErrorMessage, color: Color.red))
                .padding(Padding.default.sw())
            }
            
            Spacer()
            
            HoverButton(
                title: "confirm".localize,
                backgroundColor: Color("accent_light_2"),
                titleColor: .white, 
                isEnabled: viewModel.isValidForm
            ) {
                viewModel.onClickConfirm()
            }
            .set(animated: viewModel.loading)
            .padding(.horizontal, Padding.default.sw())
            .padding(.bottom, 8)
            
            Button {
                viewModel.requestForOTP()
            } label: {
                Text("send_again".localize)
                    .foregroundColor(viewModel.shouldResend ? Color("accent_light_2") : Color("dark_gray"))
            }
            .disabled(!viewModel.shouldResend)

        }
        .toast(
            $viewModel.showAlert,
            .init(
                displayMode: .banner(.pop),
                type: .error(.systemRed),
                title: viewModel.otpErrorMessage
            ),
            duration: 1
        )
        .onAppear {
            viewModel.onAppear()
        }
    }
}

struct OTPView_Preview: PreviewProvider {
    static var previews: some View {
        OTPView(viewModel: OtpViewModel(number: "935852415", countryCode: "+998"))
    }
}
