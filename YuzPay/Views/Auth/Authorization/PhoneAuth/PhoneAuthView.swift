//
//  PhoneAuthView.swift
//  YuzPay
//
//  Created by applebro on 17/12/22.
//

import Foundation
import SwiftUI

struct PhoneAuthView: View {
    @StateObject var viewModel = PhoneAuthViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                innerBody
            }
            .onAppear {
                viewModel.onAppear()
            }
            .fullScreenCover(item: $viewModel.routePopup, content: { dest in
                dest.screen
            })
            .navigationDestination(isPresented: $viewModel.pushToPage) {
                viewModel.route?.screen
            }
        }
        .toast($viewModel.shouldShowAlert, viewModel.alert, duration: 1)
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
                        .set(animated: viewModel.isLoading)
                        .padding(.horizontal, Padding.large)
                        .padding(.bottom, Padding.medium)
        }
    }
}

struct PhoneAuthView_Preview: PreviewProvider {
    static var previews: some View {
        PhoneAuthView()
    }
}
