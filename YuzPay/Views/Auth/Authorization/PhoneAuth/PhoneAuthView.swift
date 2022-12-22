//
//  PhoneAuthView.swift
//  YuzPay
//
//  Created by applebro on 17/12/22.
//

import Foundation
import SwiftUI
import SwiftUIX

struct PhoneAuthView: View {
    @ObservedObject var viewModel = PhoneAuthViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(tag: .uploadPhoto(model: UploadAvatarViewModel()), selection: $viewModel.route) {
                    viewModel.route?.screen
                } label: {
                    Text("")
                }
                innerBody
            }
        }
        .fullScreenCover(item: $viewModel.routePopup, content: { dest in
            dest.screen
        })
    }
    var innerBody: some View {
        VStack {
            Spacer()
            Text("authorization".localize)
                .font(.mont(.extraBold, size: 32))
                .padding(.bottom, Padding.large)
                .foregroundColor(Color("accent_light"))
            
            PhoneAuthForm(viewModel: viewModel.formViewModel)
                .padding(.horizontal, Padding.medium)
            
            Spacer()
            Spacer()
            HoverButton(title: "next".localize,
                        backgroundColor: Color("accent_light_2"),
                        titleColor: .white,
                        isEnabled: viewModel.isButtonEnabled) {
                viewModel.onClickNext()
            }
                        .padding(.horizontal, Padding.large)
                        .padding(.bottom, Padding.medium)
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

struct PhoneAuthView_Preview: PreviewProvider {
    static var previews: some View {
        PhoneAuthView()
    }
}

