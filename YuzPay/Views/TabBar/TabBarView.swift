//
//  TabBarView.swift
//  YuzPay
//
//  Created by applebro on 18/12/22.
//

import Foundation
import SwiftUIX
import SwiftUI
import Kingfisher

struct TabBarView: View {
    @ObservedObject var viewModel = TabViewModel(dataService: TabDataService())
    @State var size: CGRect = .zero
    
    var body: some View {
        StackNavigationView {
            if size == .zero {
                EmptyView()
            } else {
                innerBody
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
        .readSize($size)
        .onAppear {
            Logging.l("On Appear tabview nav")
            viewModel.onAppear()
            
            KingfisherManager.shared.cache.clearMemoryCache()
            KingfisherManager.shared.cache.cleanExpiredDiskCache()
        }
        .toast($viewModel.shouldShowAlert, viewModel.alert, duration: 1)
    }
    
    var innerBody: some View {
        ZStack(alignment: .leading) {
            sideView
                .zIndex(1)
            
            TabView(selection: $viewModel.selectedTab) {
                ZStack {
                    HomeView()
                        .environmentObject(viewModel.homeViewModel)
                        .environmentObject(viewModel)

                    Rectangle()
                        .foregroundColor(.systemBackground.opacity(0.01))
                        .frame(maxWidth: 8)
                        .ignoresSafeArea(edges: .top)
                        .fill(alignment: .leading)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged({ value in
                                    let distance = value.startLocation.x - value.location.x
                                    viewModel.onDragSideMenu((abs(distance) + -viewModel.sideMenuWidth).limitTop(0))
                                })
                                .onEnded({ value in
                                    viewModel.onEndOpeningSideMenu(value.predictedEndTranslation)
                                })
                        )
                }
                .tabItem {
                    Label("home".localize, image: "icon_home")
                }
                .tag(0)
                
                TransferTypesView()
                    .environmentObject(viewModel)
                .tabItem {
                    Label("transfer".localize, image: "icon_transfer")
                }
                .tag(1)
                
                MerchantsView()
                    .environmentObject(viewModel)
                    .tabItem {
                        Label("payment".localize, image: "icon_cart")
                    }
                    .tag(2)

                HelpView()
                    .environmentObject(viewModel)
                    .navigationTitle("help".localize)
                    .tabItem {
                        Label("help".localize, image: "icon_message")
                    }
                    .tag(3)

                SettingsView(viewModel: viewModel.settingsViewModel)
                    .environmentObject(viewModel)
                    .navigationTitle("settings".localize)
                    .tabItem {
                        Label("settings".localize, image: "icon_gear")
                    }
                    .tag(4)
            }
            .zIndex(0)
            
            NavigationLink("", isActive: $viewModel.pushSideMenuActions) {
                viewModel.sideMenuRouter?.screen
            }
        }
        .modifier(CoveredLoaderModifier(isLoading: $viewModel.isLoading))
    }
    
    var sideView: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(Color("black").opacity(0.5))
                .ignoresSafeArea()
                .opacity(Double(1 - abs(viewModel.sideMenuOffset.x) / viewModel.sideMenuWidth))
                .zIndex(1)
                .onTapGesture {
                    viewModel.hideSideBar()
                }
                
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged({ value in
                            let distance = value.startLocation.x - value.location.x
                            viewModel.onDragSideMenu(distance.limitBottom(0))
                        })
                        .onEnded({ value in
                            viewModel.onEndDragSideMenu(value.predictedEndTranslation)
                        })
                )
                
            Rectangle()
                .foregroundColor(Color("background"))
                .ignoresSafeArea()
                .frame(width: viewModel.sideMenuWidth)
                .zIndex(2)
                .overlay {
                    SideBarContent(viewModel: viewModel.sideViewModel)
                }
                .offset(x: viewModel.sideMenuOffset.x)

        }
    }
}

struct TabBarView_Preview: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}

