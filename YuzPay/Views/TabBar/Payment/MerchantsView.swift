//
//  MerchantsView.swift
//  YuzPay
//
//  Created by applebro on 24/01/23.
//

import SwiftUI
import RealmSwift

struct MerchantsView: View {
    @StateObject var viewModel: MerchantsViewModel = .init()

    @State var searchText: String = ""
    
    @State var isSearching: Bool = false
    var body: some View {
        ZStack {
            NavigationLink("", isActive: $showPaymentView) {
                if let m = viewModel.selectedMerchant, !m.isInvalidated {
                    MerchantPaymentView(merchantId: m.id)
                }
            }
            
            VStack {
                navigationView

                innerBody
            }
        }.onAppear {
            Logging.l("On appear merchants view")
            viewModel.onAppear()
        }
        .onDisappear {
            Logging.l("On disappear merchats view")
        }
        .modifier(CoveredLoaderModifier(isLoading: $viewModel.isLoading))
    }
    
    @State private var itemsPadding: CGFloat = 0
    
    @State private var showPaymentView: Bool = false
    
    @FocusState private var focusedSearchField: Bool
    
    var innerBody: some View {
        GeometryReader { proxy in
            Group {
                if searchText.isEmpty {
                    merchatsView
                } else {
                    if let merchants = viewModel.merchants {
                        searchResult {
                            ForEach(merchants.filter("title CONTAINS %@", searchText)) { merchant in
                                if !merchant.isInvalidated {
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
                        .padding(.top, 26)
                    }
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
            if let categories = viewModel.categories {
                ForEach(categories) { category in
                    VStack {
                        HStack {
                            Text(category.title.localize)
                                .mont(.medium, size: 14)
                            Spacer()
                            Button {
                                if isExpanded(category.id) {
                                    viewModel.collapse()
                                } else {
                                    viewModel.expand(category: category.id)
                                }
                            } label: {
                                Text(isExpanded(category.id) ? "collapse".localize : "see_all".localize)
                                    .mont(.regular, size: 14)
                            }
                        }
                        .padding(.horizontal, Padding.large.sw())
                        
                        merchantsContains(expanded: isExpanded(category.id)) {
                            ForEach(category.items[isExpanded(category.id) ? 0..<category.items.count : 0..<3.limitTop(category.items.count)]) { merchant in
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
                        .padding(.horizontal, isExpanded(category.id) ? 0 : Padding.default)
                        .scrollable(axis: isExpanded(category.id) ? .vertical : .horizontal)
                    }
                    .padding(.bottom, Padding.small)
                }
            }
        }
        .scrollable()
    }
    
    func isExpanded(_ id: Int) -> Bool {
        viewModel.expandedCategory == id
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
            Group {
                if isSearching {
                    YTextField(text: $searchText, placeholder: "Search")
                        .set(font: .mont(.medium, size: 14))
                        .focused($focusedSearchField)
                        .padding(.horizontal, Padding.default)
                        .frame(height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(Color("gray_light"))
                        )
                        .padding(.horizontal, Padding.default)
                        .padding(.trailing, 32)
                    
                    
                } else {
                    Text("payments".localize)
                        .font(.system(size: 16), weight: .semibold)
                        .padding()
                }
            }
            .transition(.asymmetric(
                insertion: .move(edge: .top).combined(with: .opacity),
                removal: .move(edge: .bottom).combined(with: .opacity))
            )
            
            Button {
                withAnimation {
                    isSearching.toggle()

                    focusedSearchField = isSearching

                    if !isSearching {
                        searchText = ""
                    }
                }
            } label: {
                Group {
                    if isSearching {
                        Image(systemName: "x.circle")
                    } else {
                        Image(systemName: "magnifyingglass")
                    }
                }
                .padding(.trailing, Padding.large)
                .transition(.asymmetric(
                    insertion: .move(edge: .top).combined(with: .opacity),
                    removal: .move(edge: .bottom).combined(with: .opacity))
                )

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
                .environmentObject(MerchantsViewModel())
                .onAppear {
                    MockData.shared.createMerchants()
                }
        }
    }
}
