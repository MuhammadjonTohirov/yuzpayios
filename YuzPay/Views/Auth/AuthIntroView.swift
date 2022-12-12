//
//  AuthIntroView.swift
//  YuzPay
//
//  Created by applebro on 08/12/22.
//

import Foundation
import SwiftUI

struct AuthIntroView: View {
    @State var showLogin: Bool = false
    @State var showRegister: Bool = false
    
    var body: some View {
        ZStack(alignment: .center) {
            
            GeometryReader { geoProxy in
                Image("auth_intro_image")
                    .resizable()
                    .frame(height: geoProxy.size.height * 0.83)
                    .fixedSize(horizontal: false, vertical: true)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .center, spacing: 0) {
                        Button {
                            
                        } label: {
                            HStack {
                                Text("Русский")
                                    .font(.mont(.medium, size: 14))
                                    .foregroundColor(.white)
                                Image("icon_sort_down")
                                    .resizable()
                                    .frame(width: 14, height: 9)
                            }
                            .padding(Padding.medium)
                        }

                        
                        Image("image_bank_cards_big")
                            .resizable()
                            .frame(width: 128, height: 128, alignment: .center)
                            .fixedSize()
                        
                        Text("Добро\nпожаловать!")
                            .font(.mont(.extraBold, size: 32))
                            .foregroundColor(.white)
                            .padding(Padding.default * 2)
                        
                        Text("Не следует, однако забывать, что консультация с широким активом представляет собой интересный эксперимент проверки системы обучения кадров, соответствует насущным потребностям.")
                            .padding(.leading, Padding.default)
                            .padding(.trailing, Padding.default)
                            .font(.mont(.regular, size: 14))
                            .foregroundColor(.white)
                    }
                    .multilineTextAlignment(.center)
                    
                    Spacer(minLength: 300.f.height(geoProxy.size.height))
                }
                
                VStack(alignment: .center) {
                    
                    Spacer()
                    
                    HoverButton(title: "Регистрация", height: 56.f.sh(limit: 0.2), titleColor: Color("accent")) {
                        showRegister = true
                    }
                    .padding(
                        EdgeInsets(
                            top: 0,
                            leading: Padding.default,
                            bottom: Padding.medium,
                            trailing: Padding.default
                        )
                    )
                    
                    HoverButton(title: "Вход", height: 56.f.sh(limit: 0.2), titleColor: Color("accent")) {
                        showLogin = true
                    }
                    .padding(.leading, Padding.default)
                    .padding(.trailing, Padding.default)
                }
                .frame(maxWidth: .infinity)

            }
            .fullScreenCover(isPresented: $showRegister, onDismiss: {
                showRegister = false
            }, content: AuthSignUp.init)
            .fullScreenCover(isPresented: $showLogin, onDismiss: {
                showLogin = false
            }, content: AuthSignIn.init)
            
        }
    }
}

struct AuthIntro_Preview: PreviewProvider {
    static var previews: some View {
        AuthIntroView()
    }
}
