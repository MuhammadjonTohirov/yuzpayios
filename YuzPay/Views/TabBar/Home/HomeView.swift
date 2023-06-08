//
//  HomeView.swift
//  YuzPay
//
//  Created by applebro on 18/12/22.
//

import Foundation
import SwiftUI
import RealmSwift
import YuzSDK

struct HomeView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var viewModel: TabViewModel
    @State var isEditing: Bool = false
    @ObservedResults(DCard.self, configuration: Realm.config) var cards;
    @State private var selectedMerchant: String?
    @State private var showIdentifier: Bool = false
    var body: some View {
        ZStack {
            VStack(spacing: 4) {
                VStack(alignment: .leading) {
                    navbar
                }
                .padding(.horizontal, Padding.default)
                
                VStack(spacing: Padding.large) {
                    totalAmountView
                        .padding(.top, Padding.default.sh())
                        .padding(.horizontal, Padding.default)

                    HCardListView(viewModel: homeViewModel.cardListViewModel)
                        .environmentObject(homeViewModel)
                    
                    if homeViewModel.hasInvoices {
                        HomeInvoiceListView()
                            .padding(.horizontal, Padding.default)
                            .onTapGesture {
                                homeViewModel.router = .invoices
                            }
                    }
                    
                    if !homeViewModel.isIdentifiedUser {
                        PayWithFaceView {
                            showIdentifier = true
                        }
                        .fullScreenCover(isPresented: $showIdentifier) {
                            UserIdentificationView()
                        }
                        .padding(.horizontal, Padding.default)
                    }
                    
                    MobilePaymentView { phone, merchant in
                        homeViewModel.router = .mobilePayment(args: ["phone": phone], merchantId: merchant.id)
                    }
                    .padding(.horizontal, Padding.default)
                    
                    PaymentCategoriesView { category in
                        homeViewModel.router = .merchants(category: category, selectedMerchant: $selectedMerchant, action: { selectedMerchant in
                            homeViewModel.router = .mobilePayment(args: [:], merchantId: selectedMerchant.id)
                        })
                    }
                    
                    CurrencyRateView()
                        .padding(.horizontal, Padding.default)

                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(height: 50)
                }
                .scrollable()
                Spacer()
            }
            .onAppear {
                homeViewModel.onAppear()
            }
        }
        .navigationDestination(unwrapping: $homeViewModel.router) { route in
            route.wrappedValue.screen
        }
    }
    
    var navbar: some View {
        ZStack {
            HStack(spacing: 0) {
                Button(action: {
                    self.homeViewModel.onClickMenu()
                }, label: {
                    Image("icon_menu_hamburg")
                        .resizable()
                        .frame(width: 20, height: 20)
                })
                
                Spacer()
                
                Button(action: {
                    homeViewModel.onClickNotification()
                }, label: {
                    Image("icon_bell")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .overlay(alignment: .topTrailing) {
                            Circle()
                                .offset(x: 4, y: -4)
                                .frame(width: 12, height: 12)
                                .foregroundColor(.systemRed)
                            
                        }

                })
            }
            
            Text("home".localize)
                .mont(.semibold, size: 16)
                .padding()

        }
    }
    
    var totalAmountView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Общий баланс")
                    .font(.mont(.medium, size: 16.f.sh()))
                
                HStack {
                    Text("\(cards.filter({![CreditCardType.master, .visa, .unionpay].contains($0.cardType)}).reduce(into: 0, {$0 += $1.moneyAmount}).asCurrency())")
                        .font(.mont(.bold, size: 36.f.sh()))
                    Text("сум")
                        .font(.mont(.bold, size: 18.f.sh()))
                }
            }
            
            Spacer()
        }
    }
}

struct HomeView_Preview: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HomeViewModel())
    }
}

