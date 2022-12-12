//
//  RegisterView.swift
//  YuzPay
//
//  Created by applebro on 10/12/22.
//

import Foundation
import SwiftUI

struct AuthSignUp: View {
    @ObservedObject var viewModel = SignUpViewModel()
    
    var body: some View {
        NavigationView {
            innerBody
        }
    }
    
    var innerBody: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    Spacer()
                    Text("Регистрация")
                        .font(.mont(.extraBold, size: 32))
                        .foregroundColor(Color("accent_light"))
                        .padding(.bottom, 40.f.sh())
                    
                    SignUpForm(viewModel: viewModel.formViewModel)
                        .padding(.horizontal, Padding.medium)
                    
                    HStack(spacing: 16) {
                        Image(viewModel.offerIconName)
                            .resizable()
                            .frame(width: 20.f.sw(limit: 1.6), height: 20.f.sw(limit: 1.6))
                            .onTapGesture {
                                viewModel.onClickAcceptOffer()
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
                    .padding(.horizontal, Padding.default)
                    .padding(.top, Padding.default)
                    
                    Spacer()
                    Spacer()
                    
                    HoverButton(title: "Далее)", backgroundColor: Color("accent_light_2"), titleColor: .white, isEnabled: viewModel.isSubmitEnabled) {
                        
                    }
                    .padding(.horizontal, Padding.default)
                }
                .frame(height: proxy.frame(in: .global).height)
            }
        }
    }
}

struct AuthSignUp_Preview: PreviewProvider {
    static var previews: some View {
        AuthSignUp()
    }
}
