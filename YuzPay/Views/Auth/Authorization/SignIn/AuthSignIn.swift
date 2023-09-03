//
//  AuthLogin.swift
//  YuzPay
//
//  Created by applebro on 08/12/22.
//

import Foundation
import SwiftUI

struct AuthSignIn: View {
    
    @ObservedObject var viewModel: SignInViewModel = SignInViewModel()
    @Environment(\.dismiss) var dismiss
    @FocusState var focusedField: LoginField?
    @State var text: String = ""
    private var orientation: UIDeviceOrientation = .portrait
    
    @ViewBuilder var body: some View {
        ZStack {
            Button {
                dismiss()
            } label: {
                Image("icon_x")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .fixedSize()
            }
            .zIndex(1)
            .frame(width: 20, height: 20)
            .position(x: 40, y: 20)
            
            GeometryReader { proxy in
                VStack {
                    bodyScrollView(proxy)
                                        
                    HoverButton(title: "enter".localize, backgroundColor: Color("accent_light_2"), titleColor: Color.white, isEnabled: viewModel.isFormValid) {
                        
                    }
                    .padding(.horizontal, Padding.default)
                    
                    Button {
                        
                    } label: {
                        Text("forgot_password".localize)
                            .font(.mont(.medium, size: 16))
                            .padding()
                    }
                }
            }
            .zIndex(0)
            .onAppear {
                focusedField = .username
                print("ON APPEAR")
            }
        }
    }
    
    
    func bodyScrollView(_ proxy: GeometryProxy) -> some View {
        ScrollView {
            Spacer(minLength: proxy.frame(in: .global).height * 0.3)
            VStack(spacing: 8) {
                VStack {
                    Text("entrance".localize)
                        .font(.mont(.extraBold, size: 32))
                        .padding(.bottom, 32)
                    
                    SignInForm(viewModel: viewModel.signInForm)
                        .zIndex(4)
                }
            }
        }
    }
}

struct AuthSignIn_Preview: PreviewProvider {
    static var previews: some View {
        AuthSignIn()
    }
}

