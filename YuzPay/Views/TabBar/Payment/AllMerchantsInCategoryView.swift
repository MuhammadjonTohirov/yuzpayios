//
//  AllMerchantsInCategoryView.swift
//  YuzPay
//
//  Created by applebro on 24/02/23.
//

import SwiftUI
import RealmSwift
import YuzSDK

struct AllMerchantsInCategoryView: View {
    typealias Action = (DMerchant) -> Void
    @State private var itemsPadding: CGFloat = 0
    @StateObject var viewModel: AllMerchantsInCategoryViewModel = .init()
    @Binding var selectedMerchantId: String?
    @State var category: DMerchantCategory
    var onClickMerchant: Action
    
    init(category: DMerchantCategory, selectedMerchantId: Binding<String?>, onClickMerchant: @escaping Action) {
        self.category = category
        self._selectedMerchantId = selectedMerchantId
        self.onClickMerchant = onClickMerchant
        Logging.l("Show AllMerchantsInCategory View with viewModel")
    }
    
    var body: some View {
        ZStack {
            LazyVStack {
                merchantsContains(expanded: true) {
                    autoreleasepool {
                        merchantsForEach
                    }
                }
            }
            .scrollable()
            
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .navigationTitle(viewModel.title)
        .onAppear {
            let itemsCount: CGFloat = 3
            let itemWidth: CGFloat = 100.f.sw()
            let requiredWidth = itemsCount * itemWidth
            viewModel.setCategory(self.category)
            itemsPadding = (UIScreen.screen.width  - 2 * Padding.default - requiredWidth) / 2
            viewModel.onAppear()
        }
    }
    
    @ViewBuilder
    private var merchantsForEach: some View {
        if let merchants = viewModel.merchants {
            ForEach(merchants) { merchant in
                Button {
                    self.selectedMerchantId = merchant.id
                    self.onClickMerchant(merchant)
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
