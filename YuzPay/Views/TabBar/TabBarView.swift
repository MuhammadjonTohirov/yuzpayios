//
//  TabBarView.swift
//  YuzPay
//
//  Created by applebro on 18/12/22.
//

import Foundation
import SwiftUI
import Kingfisher
import YuzSDK

struct TabBarView: View {
    @ObservedObject var viewModel = TabViewModel(dataService: TabDataService())
    @State var size: CGRect = .zero
    
    var body: some View {
        ZStack {
            NavigationView {
                if size == .zero {
                    EmptyView()
                } else {
                    innerBody
                        .navigationBarTitleDisplayMode(.inline)
                }
                
            }
            .environmentObject(viewModel.alertModel)
            MainAlertView.init(viewModel: viewModel.alertModel)
                
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
                .tag(Tab.home)
                
                TransferTypesView()
                    .environmentObject(viewModel)
                .tabItem {
                    Label("transfer".localize, image: "icon_transfer")
                }
                .tag(Tab.transfer)
                
                MerchantsView()
                    .environmentObject(viewModel.merchantsViewModel)
                    .environmentObject(viewModel)
                    .tabItem {
                        Label("payment".localize, image: "icon_cart")
                    }
                    .tag(Tab.payment)

                HelpView()
                    .environmentObject(viewModel)
                    .navigationTitle("help".localize)
                    .tabItem {
                        Label("help".localize, image: "icon_message")
                    }
                    .tag(Tab.help)

                SettingsView(viewModel: viewModel.settingsViewModel)
                    .environmentObject(viewModel)
                    .navigationTitle("settings".localize)
                    .tabItem {
                        Label("settings".localize, image: "icon_gear")
                    }
                    .tag(Tab.settings)
            }
            
            .fullScreenCover(isPresented: $viewModel.pushSideMenuActions) {
                NavigationView {
                    viewModel.sideMenuRouter?.screen
                        .toolbar(content: {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button {
                                    viewModel.pushSideMenuActions = false
                                } label: {
                                    Image(systemName: "xmark")
                                        .resizable(true)
                                        .aspectRatio(contentMode: .fit)
                                        .fixedSize()
                                        .frame(.init(width: 18, height: 18))
                                }

                            }
                        })
                }
            }
            .environment(\.rootPresentationMode, $viewModel.pushSideMenuActions)
         
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
                    // -MARK: Tab bar view
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

