//
//  OTPView.swift
//  YuzPay
//
//  Created by applebro on 11/12/22.
//

import Foundation
import SwiftUI

struct OTPView: View {
    @ObservedObject var viewModel: OtpViewModel = OtpViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 36) {
                Text("Подтверждение\nномера")
                    .font(.mont(.extraBold, size: 32))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("accent_light"))

                Text("otp_sent_to_number".localize(arguments: "+998 93 585-24-15")) { str in
                    if let range = str.range(of: "+998 93 585-24-15") {
                        str[range].font = UIFont.mont(.medium, size: 14)

                    }
                }
                .font(.mont(.regular, size: 14))
                .multilineTextAlignment(.center)
                
                YTextField(text: $viewModel.otp, placeholder: "Код подтверждения", contentType: .oneTimeCode, right: {
                    HStack {
                        Rectangle()
                            .frame(width: 0.5, height: 44)
                            .foregroundColor(Color("gray"))
                            .padding(.trailing, 4)
                        Text(viewModel.counter)
                            .foregroundColor(Color("accent_light"))
                    }
                })
                .keyboardType(.numberPad)
                .onChange(of: viewModel.otp, perform: { _ in
                    self.viewModel.onTypingOtp()
                })
                .modifier(YTextFieldBackgroundCleanStyle(padding: Padding.default))
                .padding(Padding.default)
            }
            
            Spacer()
            
            HoverButton(title: "Подтвердить", backgroundColor: Color("accent_light_2"), titleColor: .white, isEnabled: viewModel.isValidForm) {
                
            }
            .padding(.horizontal, Padding.default)
            .padding(.bottom, 8)
            
            Button {
                viewModel.resetCounter()
                viewModel.startCounter()
            } label: {
                Text("send_again".localize)
                    .foregroundColor(viewModel.shouldResend ? Color("accent_light_2") : Color("dark_gray"))
            }
            .disabled(!viewModel.shouldResend)

        }.onAppear {
            viewModel.startCounter()
        }
    }
}

struct OTPView_Preview: PreviewProvider {
    static var previews: some View {
        OTPView()
    }
}
