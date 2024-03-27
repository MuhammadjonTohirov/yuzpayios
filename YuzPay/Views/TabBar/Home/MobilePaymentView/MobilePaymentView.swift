//
//  MobilePaymentView.swift
//  YuzPay
//
//  Created by applebro on 22/12/22.
//

import Foundation
import SwiftUI
import YuzSDK

struct MobilePaymentView: View {
    @FocusState private var isFocused: Bool
    @State var number: String = ""
    var doPaymentWith: ((_ number: String, _ merchant: DMerchant) -> Void)
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 8.f.sw()) {
                Image("icon_phone_2")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("mobile_payment".localize)
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
            .onChange(of: number) { newValue in
                let code = newValue.prefix(2)
                if code.count == 2, let merchant = MerchantManager().operatorWith(code: String(code)) {
                    if newValue.onlyNumberFormat(with: "XXXXXXXXX").count == "XXXXXXXXX".count {
                        self.number.removeAll()
                        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.2) {
                            self.doPaymentWith(newValue.onlyNumberFormat(with: "XXXXXXXXX"), merchant)
                        }
                    }
                }
            }
        }
        .padding(Padding.medium)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(Color.secondarySystemBackground)
        )
        .dismissableKeyboard()
        .onAppear {
            number = ""
        }
    }
}

struct MobilePaymentView_Preview: PreviewProvider {
    static var previews: some View {
        MobilePaymentView { number, merchant in
            
        }
    }
}

