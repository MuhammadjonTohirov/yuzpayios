//
//  TabViewModel.swift
//  YuzPay
//
//  Created by applebro on 18/12/22.
//

import Foundation
import SwiftUI
import YuzSDK
import RealmSwift

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
        case .aboutUs:
            return "aboutUs"
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
    case aboutUs
    
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
        case .aboutUs:
            AboutUsView()
        }
    }
    
    static func createBy(id: String) -> SideBarRoute? {
        switch id {
        case "cards":
            return .cards
        case "monitoring":
            return .monitoring
        case "order_card":
            return .ordercard
        case "identify":
            return .identify
        case "invoices":
            return .invoices
        case "profile":
            return .profile
        case "aboutUs":
            return .aboutUs
        default:
            return nil
        }
    }
}

enum Tab: String, CaseIterable, Tabbable {
    case home
    case transfer
    case payment
    case help
    case settings
    
    var symbolImage : String {
        switch self {
        case .home:
            return "icon_home"
        case .transfer:
            return "icon_payment"
        case .payment:
            return "icon_cart"
        case .help:
            return "icon_message"
        case .settings:
            return "icon_gear"
        }
    }
    
    var icon: String {
        selectedIcon
    }
    
    var selectedIcon: String {
        switch self {
        case .home:
            return "icon_home"
        case .transfer:
            return "icon_transfer"
        case .payment:
            return "icon_cart"
        case .help:
            return "icon_message"
        case .settings:
            return "icon_gear"
        }
    }
    
    var title: String {
        self.rawValue.localize
    }
    
    // implement deeplink path convertion
    static func convert(from: String) -> Self? {
        return Tab.allCases.first { tab in
            tab.rawValue.lowercased() == from.lowercased()
        }
    }
}

enum AppRouter {
    case home(_ route: HomeViewRoute?)
    case p2p
    case pay
    case help
    case settings
}

final class TabViewModel: NSObject, ObservableObject, BaseViewModelProtocol, Loadable, Alertable {
    private(set) lazy var homeViewModel: HomeViewModel = { HomeViewModel() }()
    private(set) lazy var settingsViewModel: SettingsViewModel = { SettingsViewModel() }()
    private(set) lazy var merchantsViewModel: MerchantsViewModel = { MerchantsViewModel() }()
    private(set) var alertModel: MainAlertModel = MainAlertModel()
    private(set) lazy var sideViewModel = { SideBarViewModel() }()
    private(set) var profileNotificationToken: NotificationToken?
    var alert: AlertToast = .init(displayMode: .alert, type: .regular)
    
    @Published var pushSideMenuActions: Bool = false
    
    @Published var showSideMenu = false
    
    @Published var selectedTab: Tab = .home
    
    @Published var update: Date = Date() {
        didSet {
            homeViewModel.update = update
        }
    }
    
    @Published var isLoading: Bool = false
    
    @Published var shouldShowAlert: Bool = false
    
    @Published var tabBarStackPath: [String] = []
        
    var sideMenuRouter: SideBarRoute?
    
    var dataService: any TabDataServiceProtocol
    
    init(dataService: any TabDataServiceProtocol) {
        self.dataService = dataService
    }
    
    private var isAppeared = false
    
    func onAppear() {
        if isAppeared {
            return
        }
        UserSettings.shared.loginDate = Date()
        isAppeared = true
        homeViewModel.delegate = self
        sideViewModel.delegate = self

        getPrerequisites()
        watchProfileChange()
        DispatchQueue(label: "mock", qos: .utility).async {
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
            await dataService.loadExchangeRates()
            await MainNetworkService.shared.syncTransactionCommissions()
            dataService.loadInvoices()
            MainNetworkService.shared.syncCardList()
            MainNetworkService.shared.syncMerchants(forCategory: 1) { _ in
                
            }
            hideLoader()
        }
    }
    
    private func watchProfileChange() {
        Realm.asyncNew { realmObject in
            switch realmObject {
            case .success(let realm):
                self.profileNotificationToken = realm.objects(DUserInfo.self).observe(on: .main) { _ in
                    self.homeViewModel.reloadIsUserIdentified()
                    
                }
            case .failure:
                break
            }
        }
    }
}

extension TabViewModel: HomeViewDelegate, SideBarDelegate {
    func homeView(model: HomeViewModel, onClick route: HomeViewRoute) {
        switch route {
        case .menu:
            showSideMenu = true
        case .cards:
            sideMenuRouter = .cards
        default:
            break
        }
    }
    
    func sideBar(sideBar: SideBarViewModel, onClick route: SideMenuItem) {
        showSideMenu = false
        switch route {
        case .close:
            showSideMenu = false
        case .identify:
            sideMenuRouter = .identify
            navigate(to: SideBarRoute.identify)
        case .cards:
            sideMenuRouter = .cards
            navigate(to: SideBarRoute.cards)
        case .monitoring:
            sideMenuRouter = .monitoring
            navigate(to: SideBarRoute.monitoring)
        case .payment:
            showSideMenu = false
            selectedTab = .payment
        case .transfer:
            showSideMenu = false
            selectedTab = .transfer
        case .invoices:
            sideMenuRouter = .invoices
            navigate(to: SideBarRoute.invoices)
        case .profile:
            sideMenuRouter = .profile
            navigate(to: SideBarRoute.profile)
        case .aboutUs:
            sideMenuRouter = .aboutUs
            navigate(to: SideBarRoute.aboutUs)
        }
    }
    
    func navigate(to path: any ScreenRoute) {
        self.tabBarStackPath.append(path.id)
    }
}
