//
//  SelectCardView.swift
//  YuzPay
//
//  Created by applebro on 20/01/23.
//

import SwiftUI
import YuzSDK

struct SelectCardView: View {
    var cards: [DCard] = []
    @State var selectedCardId: String = "0"
    var onSelect: ((DCard) -> Void)
    
    var body: some View {
        VStack {
            Text("My cards")
                .mont(.semibold, size: 16)
                .padding()
                .horizontal(alignment: .leading)
            
            ForEach(cards) { card in
                HStack(spacing: Padding.default) {
                    BorderedCardIcon(name: card.cardType.localIcon)
                    cardInfo(card)
                    
                    Spacer()
                    
                    selectionButton(card)
                }
                .padding(.horizontal, Padding.default)
                .background(
                    Rectangle()
                        .foregroundColor(.systemBackground)
                        .onTapGesture {
                            selectCard(card)
                        }
                )
            }
            
            Spacer()
        }
        .onAppear {
            
        }
    }
    
    func cardInfo(_ card: DCard) -> some View {
        VStack(alignment: .leading) {
            Text((card.bankName ?? card.name) + " " + card.cardNumber.maskAsMiniCardNumber)
                .mont(.medium, size: 12)
            Text(card.moneyAmount.asCurrency)
                .mont(.semibold, size: 14)
        }
    }
    
    func selectionButton(_ card: DCard) -> some View {
        Button {
            selectCard(card)
        } label: {
            selectionIcon(card)
        }
    }
    
    func selectCard(_ card: DCard) {
        withAnimation(.easeIn(duration: 0.2)) {
            selectedCardId = card.id
            onSelect(card)
        }
    }
    
    func selectionIcon(_ card: DCard) -> some View {
        Image(selectedCardId == card.id ? "icon_record" : "icon_circle")
            .resizable()
            .frame(width: 20, height: 20)
    }
}

struct SelectCardView_Previews: PreviewProvider {
    
    static var previews: some View {
        SelectCardView(cards: CreditCardManager.shared.cards?.compactMap({$0}) ?? []) { card in
            print("Selected card \(card.id)")
        }
    }
}
