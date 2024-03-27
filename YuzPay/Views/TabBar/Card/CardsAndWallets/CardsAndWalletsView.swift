//
//  CardsAndWalletsView.swift
//  YuzPay
//
//  Created by applebro on 22/12/22.
//

import Foundation
import SwiftUI
import RealmSwift
import YuzSDK

struct CardsAndWalletsView: View {
    @State private var selectedId: String = "0"
    @StateObject var viewModel: CardsAndWalletsViewModel = CardsAndWalletsViewModel()
    @State var cardTypesMenu: Bool = false
    @EnvironmentObject var tabPath: TabViewModel
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    cardTypeItem("0", title: "all".localize, count: viewModel.cardItems.count)
                    ForEach(viewModel.cardTypesWithCounts) { item in
                        cardTypeItem(item.id, title: item.type.name, count: item.count)
                    }
                }
                .padding(Padding.medium)
                .scrollable(axis: .horizontal)
                .opacity(viewModel.cardItems.isEmpty ? 0 : 1)
                
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
                                bankName: card.holderName,
                                cardName: card.name,
                                cardNumber: card.cardNumber,
                                expireDate: card.expirationDate.toExtendedString(format: "mm / YY"),
                                amount: card.moneyAmount, 
                                isMain: card.isMain,
                                iconName: card.cardType.localIcon
                            )
                            .onTapGesture {
                                viewModel.route = .cardDetails(id: card.id)
                            }
                        }
                    }
                }
                .scrollable(axis: .vertical)
                .opacity(viewModel.cardItems.isEmpty ? 0 : 1)
                
                HoverButton(title: "add_new_card".localize,
                            leftIcon: Image(systemName: "plus.circle.fill"),
                            backgroundColor: Color("accent"),
                            titleColor: .white) {
                    cardTypesMenu = true
                }
                .padding(.horizontal, Padding.default)
                
            }
            .overlay {
                Text("no_cards".localize)
                    .foregroundColor(.gray)
                    .font(.system(size: 32.f.sw(), weight: .semibold))
                    .opacity(viewModel.cardItems.isEmpty ? 1 : 0)
            }
            .onAppear {
                viewModel.onAppear()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("my_cards".localize)
            
            BottomSheetView(isOpen: $cardTypesMenu, maxHeight: 284) {
                VStack(spacing: 16) {
                    FlatButton(title: "add".localize, borderColor: .clear) {
                        self.cardTypesMenu = false
                        
                        self.viewModel.route = .addCard
                    }
                    
                    FlatButton(title: "order_card".localize, borderColor: .clear) {
                        self.cardTypesMenu = false
                        
//                        self.viewModel.route = .orderCard
                        viewModel.showAlert(message: "coming.soon".localize)
                    }
                    
                    FlatButton(title: "virtual_card".localize, borderColor: .clear) {
                        self.cardTypesMenu = false
                        
//                        self.viewModel.route = .orderVirtualCard
                        viewModel.showAlert(message: "coming.soon".localize)
                    }
                }
                .padding(.horizontal, Padding.large)
                .mont(.semibold, size: 16)
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .navigationDestination(isPresented: $viewModel.pushNavigation, destination: {
            viewModel.route?.screen
        })
        .toast($viewModel.shouldShowAlert, viewModel.alert, duration: 1.5)
//        .navigationDestination(unwrapping: $viewModel.route, destination: { route in
//            viewModel.route?.screen
//        })
        .onDisappear {
            print("Disappear cards and wallets")
        }
    }
}

private extension CardsAndWalletsView {
    func cardItem(
        bankName: String,
        cardName: String = "card_name".localize,
        cardNumber: String,
        expireDate: String,
        amount: Float, isMain: Bool, iconName: String
    ) -> some View {
        GeometryReader { proxy in
            ZStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(bankName.uppercased())
                            .font(.mont(.semibold, size: 14))
                        Spacer()
                        Text(cardName)
                            .font(.mont(.medium, size: 14))
                        Text("\(amount.asCurrency()) uzs")
                            .font(.mont(.semibold, size: 22))
                        
                        Spacer()
                        
                        HStack(spacing: Padding.default) {
                            Text(cardNumber.maskAsCardNumber)
                            Text(expireDate)
                        }
                        .foregroundColor(.white.opacity(0.7))
                        .font(.mont(.semibold, size: 14))
                        
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

#Preview {
    
    return NavigationStack {
        CardsAndWalletsView(viewModel: CardsAndWalletsViewModel())
    }
}

