//
//  MobilePaymentView.swift
//  YuzPay
//
//  Created by applebro on 22/12/22.
//

import Foundation
import SwiftUI

struct MobilePaymentView: View {
    @FocusState private var isFocused: Bool
    @State var number: String = ""
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 8.f.sw()) {
                Image("icon_phone_2")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("Оплата телефона")
                    .font(.mont(.semibold, size: 16))
            }

            YPhoneField(text: $number, placeholder: "XX XXX-XX-XX", left: {
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
            })
            .focused($isFocused)
            .modifier(YTextFieldBackgroundGrayStyle())
            
            FlatButton(title: "do_payment".localize, borderColor: .clear, titleColor: Color.white) {
                
            }
            .height(50)
            .font(.mont(.regular, size: 15))
            .background(RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color("accent")))
        }
        .padding(Padding.medium)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(Color.secondarySystemBackground)
        )
        .dismissableKeyboard()
    }
}

struct MobilePaymentView_Preview: PreviewProvider {
    static var previews: some View {
        MobilePaymentView()
    }
}

