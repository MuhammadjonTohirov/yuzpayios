//
//  MerchantsView.swift
//  YuzPay
//
//  Created by applebro on 24/01/23.
//

import SwiftUI
import RealmSwift
import Combine
import YuzSDK

struct MerchantsView: View {
    @EnvironmentObject var viewModel: MerchantsViewModel
    
    @EnvironmentObject var tabViewModel: TabViewModel

    @StateObject var searchText: DebouncedString = .init(value: "")
    
    @State var isSearching: Bool = false

    @State private var isViewLoaded = false
    
    @State private var cancellable: AnyCancellable?
    
    @State private var isMerchantsVisible = false
    
    var body: some View {
        Group {
            innerBody
        }
        .onAppear {
            Logging.l("On appear merchants view")
            
            withAnimation {
                isMerchantsVisible = true
            }
            
            viewModel.onAppear()
        }
        .didAppear {
            isViewLoaded = true
        }
        .onDisappear {
            Logging.l("On disappear merchats view")
            withAnimation {
                isMerchantsVisible = false
            }
        }
        .onChange(of: viewModel.merchants) { _ in
            DispatchQueue.main.async {
                self.viewModel.hideLoader()
            }
        }
        .onChange(of: searchText.debouncedValue) { searchValue in
            if searchValue.count >= 3 {
                viewModel.searchMerchant(withName: searchValue)
            }
        }
    }
    
    @State var itemsPadding: CGFloat = 0
        
    @ViewBuilder
    var innerBody: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView()
            }
            
            VStack {
                navigationView
                    .frame(height: 44)
                
                if isMerchantsVisible {
                    merchantsWithSearchResultsView
                        .opacity(isViewLoaded ? 1 : 0)

                } else {
                    Spacer()
                }
            }
            .navigationDestination(unwrapping: $viewModel.route, destination: { _case in
                if case .showAllMerchantsInCategory(let category) = _case.wrappedValue  {
                    AllMerchantsInCategoryView(category: (category.title, category.id), selectedMerchantId: $viewModel.selectedMerchant) { merchant in
                        viewModel.route = nil
                        viewModel.selectedMerchant = merchant.id
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            viewModel.route = .showMerchant
                        }
                    }
                } else if let m = viewModel.selectedMerchant {
                    MerchantPaymentView(merchantId: m, args: [:])
                }
            })
            .onChange(of: viewModel.selectedMerchant, perform: { newValue in
                self.viewModel.route = .none
                
                if let id = viewModel.selectedMerchant {
                    self.viewModel.setSelected(merchantId: id)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        viewModel.route = .showMerchant
                    }
                }
            })
            .contentTransition(.opacity)
        }
    }
    
    @FocusState private var focusedSearchField: Bool
    @EnvironmentObject var alertModel: MainAlertModel
    var merchantsWithSearchResultsView: some View {
        GeometryReader { proxy in
            Group {
                if searchText.value.isEmpty {
                    merchatsView
                } else {
                    if let merchants = viewModel.merchants {
                        searchResult {
                            ForEach(merchants.filter("title CONTAINS[cd] %@", searchText.debouncedValue).prefix(20)) { merchant in
                                if !merchant.isInvalidated {
                                    Button {
                                        viewModel.setSelected(merchant: merchant)

                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            viewModel.route = .showMerchant
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
    private var navigationTitle: some View {
        if isSearching {
            YTextField(text: $searchText.value, placeholder: "Search")
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
                .mont(.semibold, size: 16)
                .padding()
        }
    }
    
    var navigationView: some View {
        ZStack {
            navigationTitle
                .transition(.asymmetric(
                    insertion: .move(edge: .top).combined(with: .opacity),
                    removal: .move(edge: .bottom).combined(with: .opacity))
                )
            
            Button {
                withAnimation {
                    isSearching.toggle()

                    focusedSearchField = isSearching

                    if !isSearching {
                        searchText.value = ""
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
                .environmentObject(MainAlertModel())
                .onAppear {
                    MockData.shared.createMerchants()
                }
        }
    }
}
