//
//  SignInForm.swift
//  YuzPay
//
//  Created by applebro on 09/12/22.
//

import Foundation
import SwiftUI

struct SignInForm: View {
    @ObservedObject var viewModel: SignInFormModel
    @FocusState var focusedField: LoginField?
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            YTextField(text: $viewModel.login, placeholder: "Login", isSecure: false, autoCapitalization: .never, left: {
                Image("icon_login")
                    .resizable()
                    .frame(width: 20, height: 19)
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 30)
            }, onCommit: {
                focusedField = .password
                viewModel.onSubmitLogin?()
            })
            .focused($focusedField, equals: .username)
            .modifier(YTextFieldBackgroundCleanStyle())
            .padding(.horizontal, Padding.medium)
            
            YTextField(text: $viewModel.password, placeholder: "Password", isSecure: true, left: {
                Image("icon_password")
                    .resizable()
                    .frame(width: 20, height: 19)
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 30)
            }, onCommit: {
                focusedField = nil
                viewModel.onSubmitPassword?()
            })
            .focused($focusedField, equals: .password)
            .modifier(YTextFieldBackgroundCleanStyle())
            .padding(.horizontal, Padding.medium)
        }.frame(height: 122)
        
            .onAppear {
                focusedField = .username
            }
    }
}

struct SignInForm_Preview: PreviewProvider {
    static var previews: some View {
        SignInForm(viewModel: SignInFormModel())
    }
}
