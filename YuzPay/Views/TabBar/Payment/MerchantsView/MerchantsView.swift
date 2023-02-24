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
    
    @State var showAllMerchants = false
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView()
            }
            
            if let catId = viewModel.expandedCategory,
                let category = viewModel.categories?.first(where: {$0.id == catId}), !category.isInvalidated {
                NavigationLink("", isActive: $showAllMerchants) {
                    AllMerchantsInCategoryView(category: category)
                }
            }
            
            if let m = viewModel.selectedMerchant, !m.isInvalidated {
                NavigationLink("", isActive: $showPaymentView) {
                    MerchantPaymentView(merchantId: m.id)
                }
            }
            
            VStack {
                navigationView
                    .frame(height: 44)
                innerBody
            }
        }.onAppear {
            Logging.l("On appear merchants view")
        }
        .didAppear {
            viewModel.onAppear()
        }
        .onDisappear {
            Logging.l("On disappear merchats view")
        }
    }
    
    @State var itemsPadding: CGFloat = 0
    
    @State var showPaymentView: Bool = false
    
    @FocusState private var focusedSearchField: Bool
    
    var innerBody: some View {
        GeometryReader { proxy in
            Group {
                if searchText.isEmpty {
                    merchatsView
                } else {
                    if let _ = viewModel.merchants {
                        searchResult {
                            Text("Search has not been implemented yet")
//                            ForEach(merchants) { merchant in
//                                if !merchant.isInvalidated {
//                                    Button {
//                                        viewModel.setSelected(merchant: merchant)
//
//                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                                            showPaymentView = true
//              9                          }
//                                    } label: {
//                                        MerchantItemView(
//                                            icon: merchant.icon,
//                                            title: merchant.title
//                                        )
//                                    }
//                                }
//                            }
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
    
    func searchResult<Content: View>(body: () -> Content) -> some View {
        LazyVGrid(columns: [
            .init(.fixed(100.f.sw()), spacing: itemsPadding),
            .init(.fixed(100.f.sw()), spacing: itemsPadding),
            .init(.fixed(100.f.sw()), spacing: itemsPadding)
        ], spacing: itemsPadding) {
            body()
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
