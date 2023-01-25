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
    @ObservedResults(DMerchant.self, configuration: Realm.config) var merchants
    @State var searchText: String = ""
    
    @State var isSearching: Bool = false
    var body: some View {
        ZStack {
            NavigationLink("", isActive: $showPaymentView) {
                if let m = selectedMerchant {
                    MerchantPaymentView(merchant: m)
                }
            }
            
            VStack {
                navigationView

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
            Group {
                if searchText.isEmpty {
                    merchatsView
                } else {
                    searchResult {
                        ForEach(merchants.filter({ merchant in
                            merchant.title.lowercased().contains(searchText.lowercased()) ||
                            merchant.type.lowercased().contains(searchText.lowercased())
                        }), id: \.title) { merchant in
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
                    .padding(.top, 26)
                }
            }
            .onAppear {
                let itemsCount: CGFloat = 3
                let itemWidth: CGFloat = 100.f.sw()
                let requiredWidth = itemsCount * itemWidth
                itemsPadding = (proxy.size.width - 2 * Padding.default - requiredWidth) / 2
            }
        }
    }
    
    var merchatsView: some View {
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
    }
    
    func isExpanded(_ title: String) -> Bool {
        expandedCategories.contains(title)
    }
    
    func searchResult<Content: View>(body: () -> Content) -> some View {
        LazyVGrid(columns: [
            .init(.fixed(100.f.sw()), spacing: itemsPadding),
            .init(.fixed(100.f.sw()), spacing: itemsPadding),
            .init(.fixed(100.f.sw()), spacing: itemsPadding)
        ], spacing: itemsPadding) {
            body()
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
    
    var navigationView: some View {
        ZStack {
            if isSearching {
                YTextField(text: $searchText, placeholder: "Search")
                    .set(font: .mont(.medium, size: 14))
                    .padding(.horizontal, Padding.default)
                    .frame(height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(Color("gray_light"))
                    )
                    .padding(.horizontal, Padding.default)
                    .padding(.trailing, 32)
                    .transition(.asymmetric(
                        insertion: .move(edge: .top).combined(with: .opacity),
                        removal: .move(edge: .bottom).combined(with: .opacity))
                    )
            } else {
                Text("payments".localize)
                    .font(.system(size: 16), weight: .semibold)
                    .padding()
                    .transition(.asymmetric(
                        insertion: .move(edge: .top).combined(with: .opacity),
                        removal: .move(edge: .bottom).combined(with: .opacity))
                    )
            }
            
            Button {
                withAnimation {
                    isSearching.toggle()
                    
                    if !isSearching {
                        searchText = ""
                    }
                }
            } label: {
                if isSearching {
                    Image(systemName: isSearching ? "x.circle" : "magnifyingglass")
                        .padding(.trailing, Padding.default)
                        .transition(.asymmetric(
                            insertion: .move(edge: .top).combined(with: .opacity),
                            removal: .move(edge: .bottom).combined(with: .opacity))
                        )
                } else {
                    Image(systemName: isSearching ? "x.circle" : "magnifyingglass")
                        .padding(.trailing, Padding.default)
                        .transition(.asymmetric(
                            insertion: .move(edge: .top).combined(with: .opacity),
                            removal: .move(edge: .bottom).combined(with: .opacity))
                        )
                }
            }
            .frame(width: 24, height: 24)
            .horizontal(alignment: .trailing)

        }
        .frame(height: 44)
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
