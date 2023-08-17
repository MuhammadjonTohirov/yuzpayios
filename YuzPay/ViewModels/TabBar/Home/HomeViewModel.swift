//
//  HomeViewModel.swift
//  YuzPay
//
//  Created by applebro on 18/12/22.
//

import Foundation
import RealmSwift
import SwiftUI
import YuzSDK

enum HomeViewRoute: ScreenRoute {
    static func == (lhs: HomeViewRoute, rhs: HomeViewRoute) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: String {
        switch self {
        case .notification:
            return "notif"
        case .menu:
            return "menu"
        case .cards:
            return "cards"
        case .addNewCard:
            return "addNewCard"
        case .showCardDetails:
            return "cardDetails"
        case .mobilePayment:
            return "mobilePayment"
        case .merchants:
            return "merchants"
        case .invoices:
            return "invoices"
        case .identification:
            return "identification"
        }
    }
    
    case menu
    case notification
    case cards
    case addNewCard
    case showCardDetails(id: String)
    case mobilePayment(args: [String: String], merchantId: String)
    case merchants(category: DMerchantCategory, selectedMerchant: Binding<String?>, action: AllMerchantsInCategoryView.Action)
    case invoices
    case identification
    
    @ViewBuilder
    var screen: some View {
        switch self {
        case .menu:
            EmptyView()
        case .notification:
            NotificationsView()
        case .cards:
            CardsAndWalletsView()
        case .addNewCard:
            AddNewCardView()
        case .showCardDetails(let id):
            CardDetailsView(cardId: id)
        case let .mobilePayment(args, merchantId):
            MerchantPaymentView(merchantId: merchantId, args: args)
        case let .merchants(cat, id, action):
            AllMerchantsInCategoryView(category: (cat.title, cat.id), selectedMerchantId: id, onClickMerchant: action)
        case .invoices:
            InvoicesView()
        case .identification:
            UserIdentificationView()
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

protocol HomeViewDelegate: NSObject {
    func homeView(model: HomeViewModel, onClick route: HomeViewRoute)
}

final class HomeViewModel: NSObject, ObservableObject, BaseViewModelProtocol, NetworkDelegate {
    weak var delegate: HomeViewDelegate?
    @Published var searchText: String = ""
    @Published var router: HomeViewRoute?
    @Published var update: Date = Date()
    @Published var isLoading: Bool = false
    
    private var invoiceNotificationToken: NotificationToken?
    
    @Published var hasInvoices: Bool = false
    @Published var isIdentifiedUser: Bool = false
    
    private(set) var selectedMerchant: String?
    private(set) var selectedCategory: Int?
    
    lazy var cardListViewModel: HCardListViewModel = {
        return HCardListViewModel()
    }()
    
    func onAppear() {
        setNetworkDelegate(self)
        watchInvoices()
        reloadIsUserIdentified()
    }
    
    func onClickMenu() {
        delegate?.homeView(model: self, onClick: .menu)
    }
    
    func onClickNotification() {
        router = .notification
    }
    
    func onClickAddNewCard() {
        router = .addNewCard
    }
    
    func onClickCard(withId id: String) {
        router = .showCardDetails(id: id)
    }
    
    func onAuthRequired() {
        DispatchQueue.main.async {
            mainRouter?.navigate(to: .auth)
        }
    }
    
    func onRefresh() {
        MainNetworkService.shared.syncCardList()
        MainNetworkService.shared.syncInvoiceList()
        Task {
            await MainNetworkService.shared.syncExchangeRate()
        }
    }
}

extension HomeViewModel {
    private func watchInvoices() {
        self.invoiceNotificationToken?.invalidate()
        
        Realm.asyncNew { realmObject in
            switch realmObject {
            case .success(let realm):
                self.invoiceNotificationToken = realm.objects(DInvoiceItem.self).observe(on: .main) { changes in
                    switch changes {
                    case .initial(let invoices):
                        self.hasInvoices = !invoices.isEmpty
                    case .update(let invoices, _, _, _):
                        self.hasInvoices = !invoices.isEmpty
                    case .error:
                        self.hasInvoices = false
                    }
                }
            case .failure:
                break
            }
        }
    }
    
    func reloadIsUserIdentified() {
        self.isIdentifiedUser = DataBase.userInfo?.isVerified ?? false
    }
}
