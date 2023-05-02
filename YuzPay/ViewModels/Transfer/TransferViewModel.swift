//
//  SelectCardViewModel.swift
//  YuzPay
//
//  Created by applebro on 20/01/23.
//

import Foundation
import RealmSwift
import SwiftUI
import YuzSDK

extension TransferType: ScreenRoute {
    var screen: some View {
        return TransferToCardView(transferType: self)
    }
}

final class TransferViewModel: ObservableObject {
    @Published var cards: Results<DCard>?
    var cardsToken: NotificationToken?
    
    @Published var route: TransferType? {
        didSet {
            showPage = route != nil
        }
    }
    
    @Published var showPage: Bool = false
    init() {
        cards = CreditCardManager.shared.cards
    }
    
    func onAppear() {
        cardsToken = cards?.observe(on: .main, { [weak self] change in
            guard let self else {
                return
            }
            
            switch change {
            case let .update(items, _, _, _):
                self.cards = items
            default:
                break
            }
        })
    }
    
    deinit {
        cardsToken?.invalidate()
    }
}
