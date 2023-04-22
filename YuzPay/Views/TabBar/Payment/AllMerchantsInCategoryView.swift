//
//  AllMerchantsInCategoryView.swift
//  YuzPay
//
//  Created by applebro on 24/02/23.
//

import SwiftUI
import RealmSwift

struct AllMerchantsInCategoryView: View {
    @State private var itemsPadding: CGFloat = 0
    @StateObject var viewModel: AllMerchantsInCategoryViewModel
    @State private var showPaymentView = false
        
    var body: some View {
        ZStack {
            if let m = viewModel.selectedMerchant, !m.isInvalidated {
                NavigationLink("", isActive: $showPaymentView) {
                    MerchantPaymentView(viewModel: .init(merchantId: m.id))
                }
            }

            if viewModel.isLoading {
                ProgressView()
            }
            
            LazyVStack {
                merchantsContains(expanded: true) {
                    autoreleasepool {
                        merchantsForEach
                    }
                }
            }.scrollable()
        }
        .navigationTitle(viewModel.title)
        .onAppear {
            let itemsCount: CGFloat = 3
            let itemWidth: CGFloat = 100.f.sw()
            let requiredWidth = itemsCount * itemWidth
            itemsPadding = (UIScreen.screen.width  - 2 * Padding.default - requiredWidth) / 2
            
            viewModel.onAppear()
        }
        .onDisappear {
            viewModel.onDisappear()
        }
    }
    
    @ViewBuilder
    private var merchantsForEach: some View {
        if let merchants = viewModel.merchants {
            ForEach(merchants) { merchant in
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
