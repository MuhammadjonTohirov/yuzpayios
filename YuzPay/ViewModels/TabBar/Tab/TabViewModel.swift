//
//  TabViewModel.swift
//  YuzPay
//
//  Created by applebro on 18/12/22.
//

import Foundation
import SwiftUI

final class TabViewModel: NSObject, ObservableObject {
    @Published var isSideBarVisible = false
    
    lazy var homeViewModel: HomeViewModel = {
        return HomeViewModel()
    }()
    
    lazy var sideViewModel: SideBarViewModel = {
        return SideBarViewModel()
    }()
    
    @Published var sideMenuOffset: CGPoint = .zero
    
    @Published var pushSideMenuActions: Bool = false
    
    @Published var sideMenuRouter: SideBarRoute? {
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
        case .notification:
            break
        case .menu:
            showSideBar()
        }
    }
    
    func sideBar(sideBar: SideBarViewModel, onClick route: SideBarRoute) {
        switch route {
        case .close:
            hideSideBar()
        case .identify:
            break
        case .cards:
            sideMenuRouter = route
            break
        }
    }
}
