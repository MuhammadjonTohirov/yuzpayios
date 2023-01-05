//
//  CreditCardManager.swift
//  YuzPay
//
//  Created by applebro on 20/12/22.
//

import Foundation
import RealmSwift

final class CreditCardManager: DManager {
    static let shared = CreditCardManager()
    
    func add(_ cards: CardModel...) {
        execute { realm in
            cards.forEach { card in
                realm.add(DCard.build(withModel: card), update: .modified)
            }
        }
    }
    
    var cards: Results<DCard>? {
        Realm.new?.objects(DCard.self)
    }
    
    func removeAll() {
        execute { realm in
            realm.delete(realm.objects(DCard.self))
        }
    }
    
    func getCard(withId id: String) -> DCard? {
        Realm.new?.object(ofType: DCard.self, forPrimaryKey: id)
    }
    
    func updateCard(forId id: String, withCard model: CardModel) {
        execute { realm in
            realm.object(ofType: DCard.self, byKey: "id", value: id)?.update(by: model)
        }
    }
    
    func makeMain(forId id: String) {
        execute { realm in
            realm.objects(DCard.self).forEach { card in
                card.set(isMain: false)
            }
            
            realm.object(ofType: DCard.self, forPrimaryKey: id)?.set(isMain: true)
        }
    }
}
