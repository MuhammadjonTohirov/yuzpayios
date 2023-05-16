//
//  ReceiptAndPayView.swift
//  YuzPay
//
//  Created by applebro on 23/01/23.
//

import SwiftUI
import RealmSwift
import PageView
import YuzSDK

struct ReceiptAndPayView: View {
    typealias Action = ((_ cardId: String) -> Void)
    @Binding var rowItems: [ReceiptRowItem]
    private var submitButtonTitle: String = "pay".localize
    private var onClickSubmit: Action = { _ in
        
    }
    
    private var requiredPrice: Float = 0
    @State private var text: String = ""
    @State private var selectedId = ""
    @State private var selectedIndex = 0
    private var showCards = false
    
    private var price: ReceiptRowItem? {
        rowItems.first(where: {$0.type == .price})
    }
    
    @ObservedResults(DCard.self, configuration: Realm.config) var cards;
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var alertModel: MainAlertModel

    private var cardHeight: CGFloat = 120
    
    @State private var isCardsVisible = false
    
    init(rows: Binding<[ReceiptRowItem]>) {
        self._rowItems = rows
    }
    
    var body: some View {
        innerBody
        .onAppear {
            selectedId = cards.first?.id ?? ""
            selectedIndex = 0
            
            showCardsView()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func showCardsView() {
        isCardsVisible = true
    }
    
    private func hideCardsView() {
        isCardsVisible = false
    }
    
    var innerBody: some View {
        VStack(alignment: .center) {
            ForEach(rowItems) { item in
                item.row
            }
            Spacer()
            
            if isCardsVisible && showCards {
                cardsView
                    .background(Color.secondarySystemBackground)
                    .transition(.opacity)
            }
            
            FlatButton(title: submitButtonTitle, titleColor: .white) {
                onClickPay()
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color("accent"))
            )
            .padding()
        }
    }
    
    private func onClickPay() {
        guard let selectedCard = self.cards.item(at: selectedIndex) else {
            return
        }
        
        if (selectedCard.moneyAmount < requiredPrice) {
            alertModel.show(title: "warning".localize, message: "insufficent_funds".localize)
            return
        }
        
        dismiss()
        self.onClickSubmit(self.cards[selectedIndex].id)
    }
    
    var cardsView: some View {
        VStack {
            HStack {
                Text("Оплата")
                    .mont(.semibold, size: 21.f.sh())
                Spacer()
            }
            .padding(.horizontal, Padding.default)
            .padding(.bottom, Padding.small)
            .padding(.top, Padding.medium)
            
            cardsPageView
        }
    }
    
    var cardsPageView: some View {
        VStack {
            SnapCarousel(spacing: 0, trailingSpace: 0, index: $selectedIndex, items: self.cards.map({$0})) { item in
                card(card: item)
            }
            .mask {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(Color.systemBackground)
                    .frame(height: cardHeight)
                    .padding(.horizontal, Padding.default)
            }
            .frame(height: cardHeight)
            .padding(.bottom, Padding.medium)

        }
    }

    func card(card: DCard) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                card.cardType.whiteIcon
                    .shadow(color: Color.black.opacity(0.12), radius: 12)
                    .offset(x: -8)
                
                Spacer()
                
                Text(card.bankName ?? "bank_name".localize)
                    .mont(.semibold, size: 14)
                HStack(spacing: 0) {
                    Text(card.cardNumber.maskAsMiniCardNumber)
                        .mont(.regular, size: 14)
                    Spacer()
                    Text(card.expirationDate.toExtendedString(format:  "MM/YY"))
                        .mont(.regular, size: 14)
                }
            }
            .padding(Padding.small)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color("accent"))
            )
            .foregroundColor(.white)
            
            
            VStack(alignment: .leading) {
                Text(card.name)
                    .mont(.semibold, size: 16.f.sw())
                Spacer()
                    .frame(maxWidth: .infinity)
                
                HStack(alignment: .bottom) {
                    Text(card.moneyAmount.asCurrency())
                        .mont(.semibold, size: 18.f.sw())
                    Text("sum")
                        .mont(.semibold, size: 14.f.sw())
                }
                
                Text("Баланс")
                    .mont(.medium, size: 12.f.sw())
                    .foregroundColor(.secondaryLabel)
            }
        }
        .padding(Padding.small)
        .padding(.horizontal, Padding.default)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .padding(.horizontal, Padding.small)
                .foregroundColor(Color.systemBackground)
        )
        .overlay {
            if requiredPrice > card.moneyAmount {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(.systemBackground)
                    .opacity(0.7)
                    .overlay {
                        Text("insufficent_funds".localize)
                            .foregroundColor(.white)
                            .mont(.semibold, size: 16)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, Padding.small)
                            .background {
                                Rectangle()
                                    .foregroundColor(.init(uiColor: .systemOrange))
                            }
                    }
                    .padding(.horizontal, Padding.small)

            }
        }
    }
    
    func row(title: String, detais: String) -> some View {
        VStack {
            HStack {
                Text(title)
                Spacer()
                Text(detais)
            }
            .padding(.vertical, Padding.small.sh())
            .padding(.horizontal, Padding.default.sw())
            
            Divider()
        }
        .foregroundColor(.label.opacity(0.85))
        .mont(.regular, size: 14)
    }
}

extension ReceiptAndPayView {
    func set(rows: [ReceiptRowItem]) -> Self {
        var v = self
        v.rowItems = rows
        v.requiredPrice = Float(v.price?.value ?? "0") ?? 0
        return v
    }
    
    func set(showCards: Bool) -> Self {
        var v = self
        v.showCards = showCards
        return v
    }
    
    func set(submitButtonTitle title: String) -> Self {
        var v = self
        v.submitButtonTitle = title
        return v
    }
    
    func set(onClickSubmit action: @escaping Action) -> Self {
        var v = self
        v.onClickSubmit = action
        return v
    }
}

struct ReceiptAndPayView_Previews: PreviewProvider {
    @State static var rows: [ReceiptRowItem] = []
    static var previews: some View {
        ReceiptAndPayView(rows: $rows)
            
            .navigationTitle("transfer_to_card".localize)
            .onAppear {
                MockData.shared.createMockCards()
            }
    }
}
