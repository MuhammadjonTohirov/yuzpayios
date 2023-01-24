//
//  TabBarView.swift
//  YuzPay
//
//  Created by applebro on 18/12/22.
//

import Foundation
import SwiftUIX
import SwiftUI

struct TabBarView: View {
    
    @StateObject var viewModel = TabViewModel()
    
    var body: some View {
        StackNavigationView {
            innerBody
                .navigationBarTitleDisplayMode(.inline) 
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
    
    var innerBody: some View {
        ZStack(alignment: .leading) {
            sideView
                .zIndex(1)
            
            TabView {
                ZStack {
                    HomeView()
                        .environmentObject(viewModel.homeViewModel)
                    
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
                
                TransferTypesView()
                    .tabItem {
                        Label("transfer".localize, image: "icon_transfer")
                    }
                
                MerchantsView()
                    .tabItem {
                        Label("payment".localize, image: "icon_cart")
                    }
                
                HelpView()
                    .navigationTitle("help".localize)
                    .tabItem {
                        Label("help".localize, image: "icon_message")
                    }
                
                SettingsView()
                    .navigationTitle("settings".localize)
                    .tabItem {
                        Label("settings".localize, image: "icon_gear")
                    }
            }
            .zIndex(0)
            NavigationLink("", isActive: $viewModel.pushSideMenuActions) {
                viewModel.sideMenuRouter?.screen
            }
        }
        .onAppear {
            Logging.l("On Appear tabview nav")
        }
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

