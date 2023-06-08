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
                    .onChange(of: viewModel.dismissView) { newValue in
                        if newValue {
                            dismiss()
                        }
                    }
            }
            .toast($viewModel.shouldShowAlert, viewModel.alert, duration: 1)
        
    }
    
    private var innerBody: some View {
        VStack(spacing: Padding.default) {
            Text("add_new_card".localize)
                .font(.mont(.semibold, size: 24))
                .padding(.bottom, 20.f.sh())
                .padding(.top, 120)
            
            YTextField(text: $viewModel.cardNumber, placeholder: "Номер карты", left: {
                Group {
                    if let cardType = viewModel.currentCardType {
                        cardType
                            .icon
                            .resizable(true)
                            .aspectRatio(contentMode: .fit)
                            .padding(.trailing, Padding.small)
                    } else {
                        Image(systemName: "creditcard.fill")
                            .foregroundColor(.secondaryLabel)
                            .padding(.trailing, Padding.small)
                    }
                }
                .frame(width: 32, height: 24)
            }, right: {
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
            .set(format: "XXXX XXXX XXXX XXXX")
            .keyboardType(.numberPad)
            .onChange(of: viewModel.cardNumber) { _ in
                self.viewModel.reloadView()
                self.viewModel.detectCardType()
            }
            .padding(.leading, Padding.medium)
            
            .modifier(YTextFieldBackgroundGrayStyle())
            
            YTextField(text: $viewModel.expireDate,
                       placeholder: "MM/YY",
                       validator: .init(filter: { text in
                let isInDateFormat = text.count == 5 && text.contains("/")
                let isValidMonth = text.prefix(2).asString.isInt && text.prefix(2).asString.asInt <= 12
                
                if isInDateFormat, isValidMonth, let date = Date.from(string: text, format: "MM/yy") {
                    return date > Date()
                }
                
                return isValidMonth
            }))
            .set(format: "XX/XX")
            .keyboardType(.numberPad)
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
            
            Spacer()
        }
        .padding(Padding.default)
        .sheet(isPresented: $viewModel.confirmAddCard) {
            OTPView(viewModel: viewModel.otpViewModel)
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

