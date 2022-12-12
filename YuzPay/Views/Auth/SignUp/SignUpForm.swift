//
//  SignUpForm.swift
//  YuzPay
//
//  Created by applebro on 10/12/22.
//

import Foundation
import SwiftUI

struct SignUpForm: View {
    @ObservedObject var viewModel: SignUpFormViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            YPhoneField(text: $viewModel.login, placeholder: "login", left: {
                HStack {
                    Text("+998")
                        .font(.mont(.medium, size: 16))
                        .padding(.leading)
                        .foregroundColor(Color("dark_gray"))
                    Rectangle()
                        .frame(width: 1, height: 40)
                        .foregroundColor(Color("gray_border"))
                }
                .padding(.trailing, Padding.default)
            }, onCommit: {
                viewModel.checkFormValidity()
            })
            .modifier(YTextFieldBackgroundCleanStyle())
            .padding(.bottom, 24)
            
            YTextField(text: $viewModel.password, placeholder: "password", isSecure: true, left: {
                Image("icon_password_2")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(.horizontal, Padding.default)
            }, onCommit: {
                viewModel.checkFormValidity()
            })
            .set(haveTitle: true)
            .modifier(YTextFieldBackgroundCleanStyle())
            .modifier(YTextFieldBottomInfo(text: "Надёжный пароль"))

            YTextField(text: $viewModel.passwordRepeate, placeholder: "repeat password", isSecure: true, left: {
                Image("icon_password_2")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(.horizontal, Padding.default)
            }, onCommit: {
                viewModel.checkFormValidity()
            })
            .set(haveTitle: true)
            .modifier(YTextFieldBackgroundCleanStyle())
            .modifier(YTextFieldBottomInfo(text: "Пароли совпадают"))
        }
    }
}

struct SignUpForm_Preview: PreviewProvider {
    static var previews: some View {
        SignUpForm(viewModel: SignUpFormViewModel())
    }
}

