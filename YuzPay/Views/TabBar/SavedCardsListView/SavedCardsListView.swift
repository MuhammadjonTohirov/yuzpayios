//
//  SavedCardsListView.swift
//  YuzPay
//
//  Created by applebro on 03/02/23.
//

import SwiftUI

struct SavedCardsListView: View {
    @State var searchText: String = ""
    @State var cards: [String] = ["", "", ""]
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(cards, id: \.self) { _ in
                        Button {} label: {
                            cardItem()
                        }
                        Divider()
                    }
                }
                .padding(.top, Padding.small)
            }
            .searchable(text: $searchText)
            .navigationTitle("cards".localize)
        }
    }
    
    func cardItem() -> some View {
        HStack(spacing: Padding.default) {
            BorderedCardIcon(name: "icon_uzcard")
            cardInfo()
            
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
    
    func cardInfo() -> some View {
        VStack(alignment: .leading) {
            Text("Abbos Hakimov".uppercased())
                .mont(.semibold, size: 14)
            Text("8600 **** **** 1232")
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
