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
    @Published var isSideBarVisible = false
    
    var homeViewModel: HomeViewModel = HomeViewModel()
    
    var sideViewModel: SideBarViewModel = SideBarViewModel()
    
    @Published var sideMenuOffset: CGPoint = .zero
    
    @Published var pushSideMenuActions: Bool = false
    
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
        sideMenuOffset = CGPoint(x: -UIScreen.screen.width * 0.8, y: 0)
        
        MockData.shared.initMockData()
    }
    
    func showSideBar() {
        withAnimation(.easeIn(duration: 0.2)) {
            self.sideMenuOffset.x = 0
            self.isSideBarVisible = true
        }
    }
    
    func hideSideBar() {
        withAnimation(.easeIn(duration: 0.2)) {
            self.sideMenuOffset.x = -UIScreen.screen.width * 0.8
            self.isSideBarVisible = false
        }
    }
    
    func onDragSideMenu(_ value: CGFloat) {
        self.sideMenuOffset.x = -(value.limitBottom(0))
    }
    
    func onEndDragSideMenu(_ predictedEndTransition: CGSize) {
        print(predictedEndTransition.width, predictedEndTransition.height)
        if abs(predictedEndTransition.width) > 150 {
            hideSideBar()
        } else {
            showSideBar()
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
        case .orderCard:
            sideMenuRouter = .ordercard
        }
    }
}
 
