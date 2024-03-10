//
//  HCardListView.swift
//  YuzPay
//
//  Created by applebro on 22/12/22.
//

import Foundation
import SwiftUI
import RealmSwift
import YuzSDK

struct HCardListView: View {
    @ObservedObject var viewModel: HCardListViewModel
    @EnvironmentObject var homeModel: HomeViewModel
    
    var body: some View {
        cardListView
            .onAppear {
                viewModel.onAppear()
            }
    }
        
    var cardListView: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image("icon_card")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("cards".localize.uppercased())
                    .font(.mont(.semibold, size: 16))
            }
            .padding(.bottom, Padding.medium)
            .padding(.horizontal, Padding.default)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    if let cards = viewModel.cards {
                        ForEach(cards.sorted(byKeyPath: "isMain", ascending: false)) { element in
                            if !element.isInvalidated {
                                cardItem(name: "\(element.cardNumber.maskAsMiniCardNumber)", icon: element.cardType.localIcon, amount: homeModel.isBalanceVisible ? element.moneyAmount.asCurrency() : "••• •••", isMain: element.isMain)
                                    .onTapGesture {
                                        self.homeModel.onClickCard(withId: element.id)
                                    }
                            } else {
                                EmptyView()
                            }
                        }
                    }

                    if (viewModel.cards?.isEmpty ?? true) {
                        addNewCardItem
                    }
                }
                .padding(.horizontal, Padding.default)
            }
        }.onAppear {
            homeModel.isBalanceVisible = UserSettings.shared.isTotalBalanceVisible ?? false
        }
    }
    
    func cardItem(name: String, icon: String, amount: String, isMain: Bool = false) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Image(icon)
                        .sizeToFit(height: 24)
                    Spacer()
                    Image(systemName: "star.circle.fill")
                        .sizeToFit(height: 16)
                        .foregroundColor(.secondaryLabel)
                        .opacity(isMain ? 0.8 : 0)
                }
                .padding(.bottom, 7)

                Text(name)
                    .font(.mont(.regular, size: 12))
                    .padding(.bottom, 2)
                    .padding(.leading, 4.f.sw())
                Text(amount)
                    .font(.mont(.bold, size: 16))
                    .padding(.leading, 4.f.sw())
                    .padding(.bottom, 10.f.sw())
            }
            
            Spacer()
        }
        .padding(.leading, 8.f.sw())
        .padding(.top, 8.f.sw())
        .padding(.trailing, 12.f.sw())
        .frame(minWidth: 150.f.sw())
        .background(
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(Color.secondarySystemBackground)
        )
    }
    
    var addNewCardItem: some View {
        Button {
            homeModel.onClickAddNewCard()
        } label: {
            Image(systemName: "plus.circle")
            .frame(minWidth: 150.f.sw(), minHeight: 80)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(Color("gray_light"))
            )
        }

    }
}

struct HCardListView_Preview: PreviewProvider {
    static var previews: some View {
        HCardListView(viewModel: HCardListViewModel())
    }
}

