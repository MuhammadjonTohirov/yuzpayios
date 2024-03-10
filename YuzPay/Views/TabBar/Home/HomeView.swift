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
    
    @ObservedResults(DCard.self, configuration: Realm.config)
    var cards;
    
    @State private var selectedMerchant: String?
    @State private var showIdentifier: Bool = false
    @State private var showAllRates: Bool = false
    @State private var refreshing: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                VStack(alignment: .leading) {
                    navbar
                }
                .padding(.horizontal, Padding.default)
                
                VStack(spacing: Padding.medium) {
                    TotalAmountView(cards: cards)
                        .padding(.top, Padding.default.sh() / 2)
                        .padding(.horizontal, Padding.default)
                        .environmentObject(homeViewModel)
                    
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
                    
                    CurrencyRateView(showMore: {
                        showAllRates = true
                    })
                    .maxWidth(.infinity)
                    .padding(.horizontal, Padding.default)

                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(height: 50)
                }
                .frame(width: UIScreen.main.bounds.width)
                .scrollable()
                .refreshable {
                    homeViewModel.onRefresh()
                }
                .onChange(of: refreshing) { newValue in
                    Logging.l(tag: "HomeView", "Refresh value \(newValue)")
                    if newValue {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            refreshing = false
                        }
                    }
                }
                
                Spacer()
            }
            
            .onAppear {
                homeViewModel.onAppear()
            }
        }
        
        .sheet(isPresented: $showAllRates, content: {
            NavigationView {
                ScrollView {
                    CurrencyRateView(showMore: {
                        Logging.l("Show more")
                    }, showAll: true)
                        .padding(Padding.default)
                    Spacer()
                }
                .navigationBarTitleDisplayMode(.inline)
//                .navigationTitle("currency_rates".localize)
            }
            .presentationDetents([.medium, .large])
        })
        .navigation(item: $homeViewModel.router, destination: { route in
            route.screen
        })
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
}

struct HomeView_Preview: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HomeViewModel())
    }
}

