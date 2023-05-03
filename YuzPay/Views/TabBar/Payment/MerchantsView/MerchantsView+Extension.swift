//
//  MerchantsView+Extension.swift
//  YuzPay
//
//  Created by applebro on 24/02/23.
//

import SwiftUI
import RealmSwift
import YuzSDK

extension MerchantsView {
    var merchatsView: some View {
        VStack(alignment: .center) {
            if let categories = viewModel.categories {
                ForEach(categories.sorted(byKeyPath: "order", ascending: true)) { category in
                    VStack {
                        HStack {
                            Image("cat\(category.id)")
                                .resizable(true)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                            Text(category.title.localize)
                                .mont(.bold, size: 14)
                            Spacer()
                            Button {
                                viewModel.expand(category: category.id)
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    viewModel.allMerchantsViewModel?.setCategory(category)
                                    showAllMerchants = true
                                }

                            } label: {
                                Text("see_all".localize)
                                    .mont(.medium, size: 14)
                                    .visible(category.merchants!.count >= 8)
                            }
                        }
                        .padding(.horizontal, Padding.default.sw())
                        .padding(.bottom, Padding.small.sw())
                        .onChange(of: showAllMerchants) { newValue in
                            if !newValue {
                                viewModel.collapse()
                            }
                        }
                        
                        merchantsContains(expanded: false) {
                            merchantsForEach(cat: category)
                        }
                        .padding(.horizontal, Padding.default)
                        .scrollable(axis: .horizontal)
                    }
                    .transaction { tr in
                        tr.animation = nil
                    }
                    .padding(.bottom, Padding.small)
                }
            }
        }
        .scrollable()
    }
    
    @ViewBuilder
    private func merchantsForEach(cat: DMerchantCategory) -> some View {
        if let merchants = cat.merchants {
            ForEach(merchants[0..<10.limitTop(merchants.count)]) { merchant in
                Button {
                    viewModel.setSelected(merchant: merchant)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        showPaymentView = true
                    }
                } label: {
                    MerchantItemView(
                        icon: merchant.icon,
                        title: merchant.title
                    )
                }
            }
        }
    }
    
    @ViewBuilder
    func merchantsContains<Content: View>(expanded: Bool, body: () -> Content) -> some View {
        if expanded {
            LazyVGrid(columns: [
                .init(.fixed(100.f.sw()), spacing: itemsPadding),
                .init(.fixed(100.f.sw()), spacing: itemsPadding),
                .init(.fixed(100.f.sw()), spacing: itemsPadding)
            ], spacing: itemsPadding) {
                body()
            }
        } else {
            LazyHGrid(rows: [.init()], spacing: itemsPadding) {
                body()
            }
        }
    }

}
