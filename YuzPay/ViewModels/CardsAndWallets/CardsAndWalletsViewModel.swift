//
//  CardsAndWalletsViewModel.swift
//  YuzPay
//
//  Created by applebro on 22/12/22.
//

import Foundation
import RealmSwift
import SwiftUI

struct CardTypeCounterItem: Identifiable, Hashable {
    var id: String {
        type.rawValue
    }
    
    var type: CreditCardType
    var count: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum CardsAndWalletsRoute: Hashable, ScreenRoute {
    static func == (lhs: CardsAndWalletsRoute, rhs: CardsAndWalletsRoute) -> Bool {
        lhs.id == rhs.id
    }

    var id: String {
        switch self {
        case .addCard:
            return "addCard"
        case .cardDetails:
            return "cardDetails"
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
        
    case addCard
    case cardDetails(id: String)
    
    @ViewBuilder
    var screen: some View {
        switch self {
        case .addCard:
            AddNewCardView()
        case .cardDetails(let id):
            CardDetailsView(cardId: id)
        }
    }
}

final class CardsAndWalletsViewModel: ObservableObject {
    @Published var cardItems: Results<DCard>
    @Published var selectedType: CreditCardType? = .uzcard
    
    @Published var cardTypesWithCounts: [CardTypeCounterItem] = []
    @Published var pushNavigation: Bool = false
    
    var route: CardsAndWalletsRoute? {
        didSet {
            pushNavigation = route != nil
        }
    }
    
    private var cardsToken: NotificationToken?

    init() {
        self.cardItems = Realm.new!.objects(DCard.self)
        Logging.l("Init cards and wallets viewmodel")
    }
    
    func onAppear() {
        setupCardSubscriber()
        reloadCategories()
    }
    
    private func setupCardSubscriber() {
        cardsToken = cardItems.observe(on: .main, { [weak self] change in
            guard let self else {
                return
            }
            
            switch change {
            case let .update(items, _, _, _):
                self.cardItems = items
                self.reloadCategories()
            default:
                break
            }
        })
    }
    
    func reloadCategories() {
        cardTypesWithCounts = []
        cardItems.forEach { c in
            if let item = cardTypesWithCounts.enumerated().first(where: {$0.element.type == c.cardType}) {
                let index = item.offset
                var obj = item.element
                obj.count += 1
                cardTypesWithCounts.remove(at: index)
                cardTypesWithCounts.append(obj)
            } else {
                cardTypesWithCounts.append(.init(type: c.cardType, count: 1))
            }
        }
    }
    
    deinit {
        cardsToken?.invalidate()
        Logging.l("Deinit cards and wallets viewmodel")
    }
}
