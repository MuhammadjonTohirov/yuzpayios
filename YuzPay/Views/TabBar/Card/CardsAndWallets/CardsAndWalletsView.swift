//
//  CardsAndWalletsView.swift
//  YuzPay
//
//  Created by applebro on 22/12/22.
//

import Foundation
import SwiftUI
import RealmSwift

struct CardsAndWalletsView: View {
    @State private var selectedId: String = "0"
    @StateObject var viewModel: CardsAndWalletsViewModel = CardsAndWalletsViewModel()
    @State var cardTypesMenu: Bool = false
    
    var body: some View {
        ZStack {
            NavigationLink("", isActive: $viewModel.pushNavigation) {
                viewModel.route?.screen
            }
            VStack {
                HStack {
                    cardTypeItem("0", title: "all".localize, count: viewModel.cardItems.count)
                    ForEach(viewModel.cardTypesWithCounts) { item in
                        cardTypeItem(item.id, title: item.type.name, count: item.count)
                    }
                }
                .padding(Padding.medium)
                .scrollable(axis: .horizontal)
                
                VStack(spacing: Padding.medium) {
                    ForEach(viewModel.cardItems.filter({ card in
                        if selectedId == "0" {
                            return true
                        } else {
                            return card.cardType.rawValue == selectedId
                        }
                    })) { card in
                        if card.isInvalidated {
                            EmptyView()
                        } else {
                            cardItem(
                                bankName: card.bankName ?? "Bank name",
                                cardNumber: card.cardNumber,
                                amount: card.moneyAmount, isMain: card.isMain, iconName: card.cardType.localIcon
                            )
                            .onTapGesture {
                                viewModel.route = .cardDetails(id: card.id)
                            }
                        }
                    }
                }
                .scrollable(axis: .vertical)
                
                HoverButton(title: "add_new_card".localize,
                            leftIcon: Image(systemName: "plus.circle.fill"),
                            backgroundColor: Color("accent_light"),
                            titleColor: .white) {
                    cardTypesMenu = true
                }
                .padding(.horizontal, Padding.default)
                
            }
            .onAppear {
                viewModel.onAppear()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("my_cards".localize)
            
            BottomSheetView(isOpen: $cardTypesMenu, maxHeight: 284) {
                VStack(spacing: 16) {
                    FlatButton(title: "Add", borderColor: .clear) {
                        self.cardTypesMenu = false
                        
                        self.viewModel.route = .addCard
                    }
                    
                    FlatButton(title: "Order a Card", borderColor: .clear) {
                        self.cardTypesMenu = false
                        
                        self.viewModel.route = .orderCard
                    }
                    
                    FlatButton(title: "Virtual Card", borderColor: .clear) {
                        
                    }
                }
                .padding(.horizontal, Padding.large)
                .mont(.semibold, size: 16)
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .onDisappear {
            print("Disappear cards and wallets")
        }
    }
}

private extension CardsAndWalletsView {
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
    
    func cardTypeItem(_ id: String, title: String, count: Int) -> some View {
        HStack {
            Text(title)
            Text("(\(count))")
        }
        .onTapGesture {
            selectedId = id
        }
        .font(.mont(.medium, size: 16))
        .padding(.horizontal, Padding.medium)
        .padding(.vertical, Padding.small)
        .foregroundColor(selectedId == id ? .white : .label)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(selectedId == id ? Color("accent") : .clear)
        )
    }
}

struct CardsAndWalletsView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CardsAndWalletsView(viewModel: CardsAndWalletsViewModel())
        }
    }
}

