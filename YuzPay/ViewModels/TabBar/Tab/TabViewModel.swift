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
        case .invoices:
            return "invoices"
        case .profile:
            return "profile"
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
        
    case cards
    case monitoring
    case ordercard
    case identify
    case invoices
    case profile
    
    @ViewBuilder
    var screen: some View {
        switch self {
        case .cards:
            CardsAndWalletsView()
        case .monitoring:
            TransactionsView()
        case .ordercard:
            OrderCardView()
        case .identify:
            UserIdentificationView()
        case .invoices:
            InvoicesView()
        case .profile:
            UserProfileView()
        }
    }
}

final class TabViewModel: NSObject, ObservableObject, BaseViewModelProtocol, Loadable, Alertable {
    private(set) lazy var homeViewModel: HomeViewModel = { HomeViewModel() }()
    private(set) lazy var settingsViewModel: SettingsViewModel = { SettingsViewModel() }()
    
    var sideViewModel = SideBarViewModel()

    var alert: AlertToast = .init(displayMode: .alert, type: .regular)

    @Published var sideMenuOffset: CGPoint = .zero
    
    @Published var pushSideMenuActions: Bool = false
    
    @Published var selectedTab: Int = 0
    
    @Published var update: Date = Date() {
        didSet {
            homeViewModel.update = update
        }
    }
    
    @Published var isLoading: Bool = false
    
    @Published var shouldShowAlert: Bool = false
        
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
    
    var dataService: any TabDataServiceProtocol
    
    init(dataService: any TabDataServiceProtocol) {
        self.dataService = dataService
    }
    
    func onAppear() {
        homeViewModel.delegate = self
        sideViewModel.delegate = self
        sideMenuOffset = CGPoint(x: -sideMenuWidth, y: 0)
        
        getPrerequisites()
        DispatchQueue(label: "mock", qos: .utility).async {
            MockData.shared.createMockCards()
            MockData.shared.createTransactions()
        }
    }
    
    private func getPrerequisites() {
        if DataBase.shouldLoadPrerequisites {
            showLoader()
        }
        
        Task {
            Logging.l(tag: "AccessToken", UserSettings.shared.accessToken ?? "")
            if !(await dataService.loadUserEntity()) {
                UserSettings.shared.clearUserDetails()
                mainRouter?.navigate(to: .auth)
                return
            }
            let _ = await dataService.loadMerchants()
            let _ = await dataService.loadSessions()
            hideLoader()
        }
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
        case .invoices:
            hideSideBar()
            sideMenuRouter = .invoices
        case .profile:
            sideMenuRouter = .profile
        }
    }
}
 
