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
                .opacity(viewModel.isSideBarVisible ? 1 : 0)
                .zIndex(1)
            
            TabView {
                HomeView()
                    .environmentObject(viewModel.homeViewModel)
                    .tabItem {
                        Label("home".localize, image: "icon_home")
                    }
                
                Text("Transactions")
                    .tabItem {
                        Label("transfer".localize, image: "icon_transfer")
                    }
                
                Text("Payments")
                    .tabItem {
                        Label("payment".localize, image: "icon_cart")
                    }
                
                Text("Help")
                    .tabItem {
                        Label("help".localize, image: "icon_message")
                    }
                
                Text("Settings")
                    .tabItem {
                        Label("settings".localize, image: "icon_menu_hamburg")
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
                .zIndex(1)
                .onTapGesture {
                    viewModel.hideSideBar()
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged({ value in
                            let distance = value.startLocation.x - value.location.x
                            viewModel.onDragSideMenu(distance)
                        })
                        .onEnded({ value in
                            viewModel.onEndDragSideMenu(value.predictedEndTranslation)
                        })
                )
            
            Rectangle()
                .foregroundColor(Color("background"))
                .ignoresSafeArea()
                .frame(width: UIScreen.screen.width * 0.8)
                .zIndex(2)
                .overlay {
                    SideBarView(viewModel: viewModel.sideViewModel)
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

