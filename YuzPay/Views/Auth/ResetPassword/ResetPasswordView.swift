//
//  ResetPassword.swift
//  YuzPay
//
//  Created by applebro on 12/12/22.
//

import Foundation
import SwiftUI

struct ResetPasswordView: View {
    @State var password = ""
    @State var repeatPassword = ""
    
    var body: some View {
        VStack(spacing: 8) {
            YTextField(text: $password, placeholder: "password".localize, isSecure: true, left: {
                Image("icon_password_2")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(.horizontal, Padding.default)
            }, onCommit: {
                
            })
            .set(haveTitle: true)
            .modifier(YTextFieldBackgroundCleanStyle())
            .modifier(YTextFieldBottomInfo(text: "reliable_password".localize))
            
            YTextField(text: $repeatPassword, placeholder: "repeat_password".localize, isSecure: true, left: {
                Image("icon_password_2")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(.horizontal, Padding.default)
            }, onCommit: {
                
            })
            .set(haveTitle: true)
            .modifier(YTextFieldBackgroundCleanStyle())
            .modifier(YTextFieldBottomInfo(text: /*Пароли совпадают*/ "password_match".localize))
        }
        .padding(.horizontal, Padding.default)
    }
}

struct ResetPasswordView_Preview: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}

