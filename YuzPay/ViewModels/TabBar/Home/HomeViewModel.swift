//
//  HomeViewModel.swift
//  YuzPay
//
//  Created by applebro on 18/12/22.
//

import Foundation
import RealmSwift
import SwiftUI

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

final class HomeViewModel: NSObject, ObservableObject {
    weak var delegate: HomeViewDelegate?
    @Published var searchText: String = ""
    @Published var router: HomeViewRoute?
    @Published var update: Date = Date()
    lazy var cardListViewModel: HCardListViewModel = {
        return HCardListViewModel()
    }()
    
    func onAppear() {

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
}
