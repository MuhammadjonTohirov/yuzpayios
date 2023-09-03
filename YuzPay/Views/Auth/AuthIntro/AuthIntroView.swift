//
//  AuthIntroView.swift
//  YuzPay
//
//  Created by applebro on 08/12/22.
//

import Foundation
import SwiftUI

struct AuthIntroView: View {
    @ObservedObject var viewModel: AuthIntroViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                innerBody
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
    
    var innerBody: some View {
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
                        
                        Text("welcome".localize)
                            .font(.mont(.extraBold, size: 32))
                            .foregroundColor(.white)
                            .padding(Padding.default * 2)
                        
                        Text("auth_welcome_info".localize)
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
                    
                    HoverButton(title: "register".localize, height: 56.f.sh(limit: 0.2), titleColor: Color("accent")) {
                        viewModel.showRegister()
                    }
                    .padding(
                        EdgeInsets(
                            top: 0,
                            leading: Padding.default,
                            bottom: Padding.medium,
                            trailing: Padding.default
                        )
                    )
                    
                    HoverButton(title: "entrance".localize, height: 56.f.sh(limit: 0.2), titleColor: Color("accent")) {
                        viewModel.showLogin()
                    }
                    .padding(.leading, Padding.default)
                    .padding(.trailing, Padding.default)
                }
                .frame(maxWidth: .infinity)

            }
            .fullScreenCover(unwrapping: $viewModel.route) { newValue in
                newValue.wrappedValue.screen
            }
        }
    }
}

struct AuthIntro_Preview: PreviewProvider {
    static var previews: some View {
        AuthIntroView(viewModel: AuthIntroViewModel())
    }
}
