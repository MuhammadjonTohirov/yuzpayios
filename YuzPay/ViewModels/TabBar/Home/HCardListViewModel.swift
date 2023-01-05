//
//  HCardListViewModel.swift
//  YuzPay
//
//  Created by applebro on 22/12/22.
//

import Foundation
import SwiftUI
import RealmSwift

class HCardListViewModel: ObservableObject {
    @Published var cards: Results<DCard>?
    private var cardsToken: NotificationToken?
    
    func onAppear() {
        guard let realm = Realm.new else {
            return
        }
        
        cards = realm.objects(DCard.self)
     
        cardsToken = cards?.observe(on: .main, { [weak self] change in
            guard let self else {
                return
            }
            
            switch change {
            case let .initial(items):
                withAnimation {
                    self.cards = items
                }
            case let .update(items, _, _, _):
                withAnimation {
                    self.cards = items
                }
            default:
                break
            }
        })
    }
    
    deinit {
        cardsToken?.invalidate()
    }
}
