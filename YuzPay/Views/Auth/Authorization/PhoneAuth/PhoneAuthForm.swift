//
//  PhoneAuthForm.swift
//  YuzPay
//
//  Created by applebro on 17/12/22.
//

import Foundation
import SwiftUI

struct PhoneAuthForm: View {
    @ObservedObject var viewModel: PhoneAuthFormViewModel = PhoneAuthFormViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            YPhoneField(text: $viewModel.phoneNumber, placeholder: "login", left: {
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
            .onChange(of: viewModel.phoneNumber, perform: { newValue in
                self.viewModel.validateForm()
            })
            .modifier(YTextFieldBackgroundCleanStyle())
            .padding(.bottom, 24)
            
            HStack(spacing: 16) {
                Image(viewModel.offerIconName)
                    .resizable()
                    .frame(width: 20.f.sw(limit: 1.6), height: 20.f.sw(limit: 1.6))
                    .onTapGesture {
                        viewModel.toggleOffer()
                        viewModel.validateForm()
                    }
                
                Text(
                    "public_offer".localize, configure: { attr in
                        if let range = attr.range(of: "the_offer".localize) {
                            attr[range].foregroundColor = Color("accent_light")
                            attr[range].link = URL(string: "https://google.com")
                            attr[range].underlineStyle = NSUnderlineStyle.single
                        }
                    }
                )
                .font(.mont(.regular, size: 16))
            }
            .padding(.top, Padding.default)
        }
    }
}

struct PhoneAuthForm_Preview: PreviewProvider {
    static var previews: some View {
        PhoneAuthForm()
    }
}

