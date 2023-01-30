//
//  TabViewModel.swift
//  YuzPay
//
//  Created by applebro on 18/12/22.
//

import Foundation
import SwiftUI
import SwiftUIX

enum SideBarRoute: Hashable, ScreenRoute {
    static func == (lhs: SideBarRoute, rhs: SideBarRoute) -> Bool {
        lhs.id == rhs.id
    }

    var id: String {
        switch self {
        case .cards:
            return "cards"
        case .monitoring:
            return "monitoring"
        case .ordercard:
            return "order_card"
        case .identify:
            return "identify"
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
        
    case cards
    case monitoring
    case ordercard
    case identify
    @ViewBuilder
    var screen: some View {
        switch self {
        case .cards:
            CardsAndWalletsView()
        case .monitoring:
            TransactionsView()
        case .ordercard:
            StackNavigationView {
                OrderCardView()
            }
        case .identify:
            UserIdentificationView()
        }
    }
}

final class TabViewModel: NSObject, ObservableObject {
    var homeViewModel: HomeViewModel = HomeViewModel()
    
    var sideViewModel: SideBarViewModel = SideBarViewModel()
    
    @Published var sideMenuOffset: CGPoint = .zero
    
    @Published var pushSideMenuActions: Bool = false
    
    @Published var selectedTab: Int = 0
    
    var sideMenuWidth: CGFloat {
        UIScreen.screen.width * 0.8
    }
    
    var sideMenuRouter: SideBarRoute? {
        didSet  {
            pushSideMenuActions = sideMenuRouter != nil
            if pushSideMenuActions {
                hideSideBar()
            }
        }
    }
    
    func onAppear() {
        homeViewModel.delegate = self
        sideViewModel.delegate = self
        sideMenuOffset = CGPoint(x: -sideMenuWidth, y: 0)
        
        MockData.shared.initMockData()
    }
    
    func showSideBar() {
        withAnimation(.easeIn(duration: 0.2)) {
            self.sideMenuOffset.x = 0
        }
    }
    
    func hideSideBar() {
        withAnimation(.easeOut(duration: 0.2)) {
            self.sideMenuOffset.x = -UIScreen.screen.width * 0.8
        }
    }
    
    func onDragSideMenu(_ value: CGFloat) {
        self.sideMenuOffset.x = -abs(value)
    }
    
    func onEndDragSideMenu(_ predictedEndTransition: CGSize) {        
        if abs(predictedEndTransition.width) > 150 {
            hideSideBar()
        } else {
            showSideBar()
        }
    }
    
    func onEndOpeningSideMenu(_ predictedEndTransition: CGSize) {
        if abs(predictedEndTransition.width) >= 150 {
            showSideBar()
        } else {
            hideSideBar()
        }
    }
}

extension TabViewModel: HomeViewDelegate, SideBarDelegate {
    func homeView(model: HomeViewModel, onClick route: HomeViewRoute) {
        switch route {
        case .menu:
            showSideBar()
        case .cards:
            sideMenuRouter = .cards
        default:
            break
        }
    }
    
    func sideBar(sideBar: SideBarViewModel, onClick route: SideMenuItem) {
        switch route {
        case .close:
            hideSideBar()
        case .identify:
            sideMenuRouter = .identify
        case .cards:
            sideMenuRouter = .cards
        case .monitoring:
            sideMenuRouter = .monitoring
        case .payment:
            hideSideBar()
            selectedTab = 2
        case .transfer:
            hideSideBar()
            selectedTab = 1
        }
    }
}
 
