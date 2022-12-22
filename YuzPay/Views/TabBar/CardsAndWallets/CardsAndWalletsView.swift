//
//  CardsAndWalletsView.swift
//  YuzPay
//
//  Created by applebro on 22/12/22.
//

import Foundation
import SwiftUI

struct CardsAndWalletsView: View {
    @State var selectedId: Int = 0
    @ObservedObject var viewModel: CardsAndWalletsViewModel = CardsAndWalletsViewModel()
    
    var body: some View {
        VStack {
            HStack {
                cardTypeItem(0, title: "all".localize, count: 3)
                cardTypeItem(1, title: "uzcard".localize, count: 1)
                cardTypeItem(2, title: "visa".localize, count: 1)
                cardTypeItem(3, title: "master".localize, count: 1)
            }
            .padding(Padding.medium)
            .scrollable(axis: .horizontal)
            
            VStack(spacing: Padding.medium) {
                ForEach(viewModel.cards) { card in
                    cardItem(
                        bankName: card.bankName ?? "Bank name",
                        cardNumber: card.cardNumber,
                        amount: card.moneyAmount, isMain: card.isMain, iconName: card.cardType.localIcon
                    )
                }
            }
            .scrollable(axis: .vertical)
        }
        .toolbar(content: {
            ToolbarItem {
                Button {
                    
                } label: {
                    Image(systemName: "plus.circle")
                }
            }
        })
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("my_cards".localize)
    }
    
    func cardItem(bankName: String,
                  cardName: String = "Название карты",
                  cardNumber: String,
                  amount: Float, isMain: Bool, iconName: String) -> some View {
        GeometryReader { proxy in
            ZStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(bankName.uppercased())
                            .font(.mont(.semibold, size: 12))
                        Spacer()
                        Text(cardName)
                            .font(.mont(.medium, size: 14))
                        Text("\(amount.asCurrency) сум")
                            .font(.mont(.semibold, size: 20))
                        
                        Spacer()
                        
                        HStack(spacing: Padding.default) {
                            Text(cardNumber)
                            Text("05 / 25")
                        }
                        .foregroundColor(.white.opacity(0.7))
                        .font(.mont(.medium, size: 13))
                        
                    }
                    .foregroundColor(.white)
                    .padding(Padding.medium)

                    Spacer()
                }
                Spacer()
                
                if isMain {
                    Image("icon_main_card")
                        .resizable()
                        .frame(width: 36, height: 36)
                        .position(x: proxy.frame(in: .local).width - 26, y: 26)
                }
                    
                Image(iconName)
                    .resizable()
                    .sizeToFit(height: 32)
                    .frame(maxWidth: 40)
                    .position(x: proxy.frame(in: .local).width - 32, y: proxy.frame(in: .local).height - 30)
                    .foregroundColor(.white)

            }
        }
        .frame(minHeight: 122)
        .background(Color("accent"))
        .cornerRadius(16, style: .circular)
        .padding(.horizontal, Padding.medium)
    }
    
    func cardTypeItem(_ id: Int, title: String, count: Int) -> some View {
        HStack {
            Text(title)
            Text("(\(count))")
        }
        .font(.mont(.medium, size: 16))
        .padding(.horizontal, Padding.medium)
        .padding(.vertical, Padding.small)
        .foregroundColor(selectedId == id ? .white : .label)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(selectedId == id ? Color("accent_light_2") : .clear)
        )
    }
}

struct CardsAndWalletsView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CardsAndWalletsView()
        }
    }
}

