//
//  ResetPasswordNumberView.swift
//  YuzPay
//
//  Created by applebro on 12/12/22.
//

import Foundation
import SwiftUI

struct ResetPasswordNumberView: View {
    @State var login: String = ""
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            Text("Восстановление пароля")
                .font(.mont(.extraBold, size: 32))
                .multilineTextAlignment(.center)
                .foregroundColor(Color("accent_light"))
            YPhoneField(text: $login, placeholder: "93 585-24-15", left: {
                HStack {
                    Image("icon_login")
                        .resizable()
                        .frame(width: 20, height: 19)
                        .aspectRatio(contentMode: .fit)
                        .padding(.trailing, Padding.small)
                    Text("+998")
                        .font(.mont(.medium, size: 16))
                }
                .padding(.leading, 30)
                .padding(.trailing, Padding.small)
            }, onCommit: {
            })
            .modifier(YTextFieldBackgroundCleanStyle())
            .padding(.horizontal, Padding.medium)
            
            Spacer()
            Spacer()
            HoverButton(
                title: "Далее",
                backgroundColor: Color("accent_light_2"),
                titleColor: .white)
            {
                
            }
            .padding(.horizontal, Padding.default)
        }
    }
}

struct ResetPasswordNumberView_Preview: PreviewProvider {
    static var previews: some View {
        ResetPasswordNumberView()
    }
}

