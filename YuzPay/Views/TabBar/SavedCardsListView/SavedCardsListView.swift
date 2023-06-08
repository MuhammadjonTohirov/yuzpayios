//
//  SavedCardsListView.swift
//  YuzPay
//
//  Created by applebro on 03/02/23.
//

import SwiftUI
import RealmSwift
import YuzSDK

struct SavedCardsListView: View {
    @State var searchText: String = ""
    @ObservedResults(DSavedCard.self, configuration: Realm.config) var cards;
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(cards, id: \.self) { card in
                        Button {} label: {
                            cardItem(type: card.cardType, name: card.holderName.nilIfEmpty ?? card.name, card: card.cardNumber)
                        }
                        Divider()
                    }
                }
                .padding(.top, Padding.small)
            }
            .searchable(text: $searchText)
            .navigationTitle("cards".localize)
        }
        .onAppear {
            MainNetworkService.shared.syncSavedCards()
        }
    }
    
    func cardItem(type: CreditCardType, name: String, card: String) -> some View {
        HStack(spacing: Padding.default) {
            BorderedCardIcon(name: type.localIcon)
            cardInfo(name: name, card: card)
            
            Spacer()
            
        }
        .background(
            Rectangle()
                .foregroundColor(.systemBackground)
                .onTapGesture {
                    
                }
        )
        .padding(.horizontal, Padding.default)

    }
    
    func cardInfo(name: String, card: String) -> some View {
        VStack(alignment: .leading) {
            Text(name.uppercased())
                .mont(.semibold, size: 14)
            Text(card)
                .mont(.medium, size: 14)
        }
    }
}

struct SavedCardsListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SavedCardsListView()
        }
    }
}
