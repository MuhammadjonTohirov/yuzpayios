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
        }
    }
    
    case menu
    case notification
    case cards
    case addNewCard
    case showCardDetails(id: String)
    
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
        }
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
    
    lazy var cardListViewModel: HCardListViewModel = {
        return HCardListViewModel()
    }()
    
    func onAppear() {
        setNetworkDelegate(self)
        watchInvoices()
        watchUserIdentifer()
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
}

extension HomeViewModel {
    private func watchInvoices() {
        self.invoiceNotificationToken?.invalidate()
        
        Realm.asyncNew { realmObject in
            switch realmObject {
            case .success(let realm):
                self.invoiceNotificationToken = realm.objects(DInvoiceItem.self).observe(on: .main) { changes in
                    switch changes {
                    case .initial(let collectionType):
                        self.hasInvoices = !collectionType.isEmpty
                    case .update(let collectionType, _, _, _):
                        self.hasInvoices = !collectionType.isEmpty
                    case .error:
                        self.hasInvoices = false
                    }
                }
            case .failure:
                break
            }
        }
    }
    
    private func watchUserIdentifer() {
        self.isIdentifiedUser = UserSettings.shared.isVerifiedUser ?? false
    }
}
