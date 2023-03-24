//
//  CardDetailsView.swift
//  YuzPay
//
//  Created by applebro on 31/12/22.
//

import SwiftUI

struct CardDetailsView: View {
    var cardId: String
    @State private var cardName: String = ""
    @State private var isMain: Bool = false
    @State private var showIsMainIcon: Bool = false
    @State private var showDeleteAlert: Bool = false
    @State private var showToastAlert: Bool = false
    @State private var alertToast: AlertToast = .init(displayMode: .alert, type: .regular)
    @Environment(\.dismiss) var dismiss

    var card: DCard? {
        CreditCardManager.shared.getCard(withId: cardId)
    }
    
    var body: some View {
        Rectangle()
            .ignoresSafeArea()
            .foregroundColor(.systemBackground)
            .overlay {
                innerBody
            }
            .toast($showToastAlert, alertToast, duration: 1)
    }
    
    private var innerBody: some View {
        VStack(alignment: .leading, spacing: 0) {
            cardView
                .background(Color.secondarySystemBackground)
            
            if card != nil {
                YTextField(text: $cardName, placeholder: "card_name".localize)
                    .set(haveTitle: true)
                    .padding(.horizontal, Padding.medium)
                    .modifier(YTextFieldBackgroundGrayStyle())
                    .padding(Padding.default)
                
                Divider()
            
                Text("actions".localize.capitalized)
                    .font(.mont(.semibold, size: 14))
                    .padding(.horizontal, Padding.default)
                    .frame(height: 60)
                
                Divider()
            
                VStack(spacing: 0) {
                    rowItem(
                        leftImage: Image("icon_star")
                            .resizable()
                            .renderingMode(.template),
                        title: "main_card".localize) {
                            Toggle(isOn: $isMain, label: {
                                EmptyView()
                            })
                        }
                    
                    Divider()
                    
                    rowItem(
                        leftImage: Image("icon_lock")
                            .resizable()
                            .renderingMode(.template),
                        title: "block".localize.capitalized) {
                            EmptyView()
                        }
                    
                    Divider()
                    
                    rowItem(
                        leftImage: Image("icon_trash")
                            .resizable()
                            .renderingMode(.template),
                        title: "delete".localize.capitalized) {
                            EmptyView()
                        }
                        .onTapGesture {
                            showDeleteCardAlert()
                        }
                }
                .foregroundColor(Color.label)
                .listRowSeparator(.hidden)
            }
            
            Spacer()
        }
        .navigationTitle(card?.name ?? "cards")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            cardName = card?.name ?? ""
            isMain = card?.isMain ?? false
        }
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Delete Card"),
                message: Text("Are you sure you want to delete this card?"),
                primaryButton: .destructive(Text("Delete")) {
                    deleteCard()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private func showDeleteCardAlert() {
        self.showDeleteAlert = true
    }
    
    private func deleteCard() {
        CreditCardManager.shared.deleteCard(withId: cardId)
        alertToast = .init(displayMode: .alert, type: .complete(.secondaryLabel), title: "Card has been delete")
        showToastAlert = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            dismiss()
        }
    }
    
    private func rowItem(leftImage: some View, title: String, right: () -> some View) -> some View {
        Rectangle()
            .foregroundColor(.systemBackground)
            .overlay {
                HStack(spacing: Padding.default) {
                    leftImage
                        .foregroundColor(Color("dark_gray"))
                        .frame(width: 20, height: 20)
                    Text(title)
                        .font(.mont(.regular, size: 14))
                    Spacer()
                    right()
                }
                .padding(.horizontal, Padding.default)
            }
            .frame(height: 60)
    }
    
    @ViewBuilder
    private var cardView: some View {
        if let _card = card {
            CardLargeView(
                bankName: _card.bankName ?? "",
                cardName: cardName,
                deposit: _card.moneyAmount.asCurrency, currency: "sum", cardType: _card.cardType,
                ownerName: _card.name,
                cardNumber: _card.cardNumber, expireDate: _card.expirationDate.toExtendedString(format: "MM/YY"),
                isMain: isMain)
            .padding(Padding.default)
        } else {
            EmptyView()
        }
    }
}

struct CardDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        CardDetailsView(cardId: "0")
    }
}
