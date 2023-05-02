//
//  AddCardView.swift
//  YuzPay
//
//  Created by applebro on 22/12/22.
//

import Foundation
import SwiftUI
import RealmSwift

struct AddNewCardView: View {
    @StateObject private var viewModel: AddNewCardViewModel = AddNewCardViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Rectangle()
            .ignoresSafeArea()
            .foregroundColor(.systemBackground)
            .overlay {
                innerBody
            }
            .toast($viewModel.shouldShowAlert, viewModel.alert, duration: 1)

    }
    
    private var innerBody: some View {
        ZStack {
            VStack(spacing: Padding.default) {
                Text("add_new_card".localize)
                    .font(.mont(.semibold, size: 28))
                    .padding(.bottom, 20.f.sh())

                YFormattedField(text: $viewModel.cardNumber, placeholder: "Номер карты", format: "XXXX XXXX XXXX XXXX", right: {
                    Button {
                        viewModel.onClickScanCard()
                    } label: {
                        Image("icon_camera")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                            .padding(Padding.medium)
                            .background {
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(Color("gray"))
                            }
                            .padding(Padding.small / 2)
                    }
                    .fullScreenCover(isPresented: $viewModel.scanCard) {
                        scanCardView
                    }
                })
                .onChange(of: viewModel.cardNumber) { _ in
                    self.viewModel.reloadView()
                }
                    .padding(.leading, Padding.medium)
                    
                    .modifier(YTextFieldBackgroundGrayStyle())
                
                YFormattedField(text: $viewModel.expireDate, placeholder: "Срок истечения", format: "XX/XX")
                    .padding(.leading, Padding.medium)
                    .modifier(YTextFieldBackgroundGrayStyle())
                    .onChange(of: viewModel.expireDate) { _ in
                        self.viewModel.reloadView()
                    }
                
                YTextField(text: $viewModel.cardName, placeholder: "Название карты")
                    .padding(.leading, Padding.medium)
                    .modifier(YTextFieldBackgroundGrayStyle())
                    .onChange(of: viewModel.cardName) { _ in
                        self.viewModel.reloadView()
                    }
                
                HoverButton(title: "Save", backgroundColor: Color("accent"), titleColor: .white, isEnabled: viewModel.isActive) {
                    viewModel.addNewCard()
                }
                .set(animated: viewModel.isLoading)
                .padding(.top, 20)
            }
            .padding(Padding.default)
            .sheet(isPresented: $viewModel.confirmAddCard) {
                OTPView(viewModel: viewModel.otpViewModel)
            }
        }
    }
    
    @ViewBuilder var scanCardView: some View {
        CardReaderWrapper { cardNumber, expireDate in
            self.viewModel.cardNumber = cardNumber
            self.viewModel.expireDate = expireDate
        }
        .ignoresSafeArea(.all)
    }
}

struct AddNewCardView_Preview: PreviewProvider {
    static var previews: some View {
        AddNewCardView()
    }
}

