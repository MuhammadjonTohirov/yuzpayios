//
//  MerchantsView.swift
//  YuzPay
//
//  Created by applebro on 24/01/23.
//

import SwiftUI
import RealmSwift

struct MerchantsView: View {
    @ObservedResults(DMerchantCategory.self, configuration: Realm.config) var categories
    
    var body: some View {
        ZStack {
            NavigationLink("", isActive: $showPaymentView) {
                if let m = selectedMerchant {
                    MerchantPaymentView(merchant: m)
                }
            }
            
            VStack {
                Text("payments".localize)
                    .font(.system(size: 16), weight: .semibold)
                    .padding()

                innerBody
            }
        }
    }
    
    @State private var itemsPadding: CGFloat = 0
    
    @State private var expandedCategories: Set<String> = []
    
    @State private var showPaymentView: Bool = false
    
    @State private var selectedMerchant: DMerchant?

    var innerBody: some View {
        GeometryReader { proxy in
            LazyVStack(alignment: .center) {
                ForEach(categories, id: \.self) { category in
                    VStack {
                        HStack {
                            Text(category.title.localize)
                                .mont(.medium, size: 14)
                            Spacer()
                            Button {
                                if isExpanded(category.title) {
                                    expandedCategories.remove(category.title)
                                } else {
                                    expandedCategories.insert(category.title)
                                }
                            } label: {
                                Text(isExpanded(category.title) ? "collapse".localize : "see_all".localize)
                                    .mont(.regular, size: 14)
                            }
                            .visible(category.items.count > 3)
                        }
                        .padding(.horizontal, Padding.large.sw())
                        
                        merchantsContains(expanded: isExpanded(category.title)) {
                            ForEach(category.items, id: \.title) { merchant in
                                Button {
                                    selectedMerchant = merchant
                                    
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
                        .padding(.horizontal, isExpanded(category.title) ? 0 : Padding.default)
                        .scrollable(axis: isExpanded(category.title) ? .vertical : .horizontal)
                    }
                    .padding(.bottom, Padding.small)
                }
            }
            .scrollable()
            .onAppear {
                let itemsCount: CGFloat = 3
                let itemWidth: CGFloat = 100.f.sw()
                let requiredWidth = itemsCount * itemWidth
                itemsPadding = (proxy.size.width - 2 * Padding.default - requiredWidth) / 2
            }
        }
    }
    
    func isExpanded(_ title: String) -> Bool {
        expandedCategories.contains(title)
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


struct MerchantsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MerchantsView()
                .onAppear {
                    MockData.shared.createMerchants()
                }
        }
    }
}
