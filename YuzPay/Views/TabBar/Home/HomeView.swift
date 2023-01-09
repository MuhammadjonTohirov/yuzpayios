//
//  HomeView.swift
//  YuzPay
//
//  Created by applebro on 18/12/22.
//

import Foundation
import SwiftUI
import SwiftUIX
import RealmSwift

struct HomeView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @State var isEditing: Bool = false

    var body: some View {
        ZStack {
            NavigationLink(unwrapping: $viewModel.router) { isActive in
                Logging.l("Is active \(isActive)")
            } destination: { route in
                route.wrappedValue.screen
            } label: {
                Text("")
            }
            
            VStack(spacing: 4) {
                VStack(alignment: .leading) {
                    navbar
                }
                .padding(.horizontal, Padding.default)
                
                VStack(spacing: Padding.large) {
                    totalAmountView
                        .padding(.top, 40.f.sh())
                        .padding(.horizontal, Padding.default)

                    HCardListView(viewModel: viewModel.cardListViewModel)
                        .environmentObject(viewModel)
                    
                    InvoiceListView()
                        .padding(.horizontal, Padding.default)
                    
                    PayWithFaceView()
                        .padding(.horizontal, Padding.default)
                    
                    MobilePaymentView()
                        .padding(.horizontal, Padding.default)

                    PaymentCategoriesView()
                    
                    SavedPaymentsView()
                    
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
                viewModel.onAppear()
            }
        }
    }
    
    var navbar: some View {
        HStack(spacing: 0) {
            Button(action: {
                self.viewModel.onClickMenu()
            }, label: {
                Image("icon_menu_hamburg")
                    .resizable()
                    .frame(width: 20, height: 20)
            })
            
            YTextField(text: $viewModel.searchText, placeholder: "Search")
                .set(font: .mont(.medium, size: 14))
                .padding(.horizontal, Padding.default)
                .frame(height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(Color("gray_light"))
                )
                .padding(.horizontal, Padding.default)
            
            Button(action: {
                viewModel.onClickNotification()
            }, label: {
                Image("icon_bell")
                    .resizable()
                    .frame(width: 20, height: 20)
                
            })
        }
    }
    
    var totalAmountView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Общий баланс")
                    .font(.mont(.medium, size: 16.f.sh()))
                
                HStack {
                    Text("500 000")
                        .font(.mont(.bold, size: 36.f.sh()))
                    Text("сум")
                        .font(.mont(.bold, size: 18.f.sh()))
                }
            }
            
            Spacer()
            
            Image("icon_star")
                .resizable()
                .frame(width: 20, height: 20)
        }
    }
}

struct HomeView_Preview: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

