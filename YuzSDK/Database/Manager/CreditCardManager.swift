//
//  CreditCardManager.swift
//  YuzPay
//
//  Created by applebro on 20/12/22.
//

import Foundation
import RealmSwift

final public class CreditCardManager: DManager {
    public static let shared = CreditCardManager()
    
    public func add(_ cards: CardModel...) {
        execute { realm in
            cards.forEach { card in
                realm.add(DCard.build(withModel: card), update: .modified)
            }
        }
    }
    
    public func addAll<T>(_ items: [T]) where T : ModelProtocol {
        execute { realm in
            let models = items.map({$0 as! CardModel})
            let deletingCards = realm.objects(DCard.self).filter("NOT (id IN %@)", models.map({"\($0.id)"}))
            realm.delete(deletingCards)
            
            models.forEach { item in
                realm.add(DCard.build(withModel: item), update: .modified)
            }
        }
    }
    
    public func addSavedCards<T>(_ items: [T]) where T : ModelProtocol {
        execute { realm in
            let models = items.map({$0 as! CardModel})
            let deletingCards = realm.objects(DSavedCard.self).filter("NOT (id IN %@)", models.map({"\($0.id)"}))
            realm.delete(deletingCards)
            
            models.forEach { item in
                realm.add(DSavedCard.build(withModel: item), update: .modified)
            }
        }
    }
    
    public var cards: Results<DCard>? {
        Realm.new?.objects(DCard.self).sorted(byKeyPath: "isMain")
    }
    
    public var mainCard: DCard? {
        cards?.first(where: {$0.isMain})
    }
    
    public var all: Results<DCard>? {
        cards
    }
    
    public func update(forId id: String, name: String) {
        execute { realm in
            realm.object(ofType: DCard.self, byKey: "id", value: id)?.name = name
        }
    }
    
    public func update(forId id: String, isMain: Bool) {
        execute { realm in
            realm.objects(DCard.self).filter("isMain = %d", isMain).first?.isMain = !isMain
            realm.object(ofType: DCard.self, byKey: "id", value: id)?.isMain = isMain
        }
    }
    
    public func removeAll() {
        execute { realm in
            realm.delete(realm.objects(DCard.self))
        }
    }
    
    public func getCard(withId id: String) -> DCard? {
        Realm.new?.object(ofType: DCard.self, forPrimaryKey: id)
    }
    
    public func deleteCard(withId id: String) {
        if let realm = Realm.new, let card = realm.object(ofType: DCard.self, forPrimaryKey: id) {
            realm.trySafeWrite {
                realm.delete(card)
            }
        }
    }
    
    public func updateCard(forId id: String, withCard model: CardModel) {
        execute { realm in
            realm.object(ofType: DCard.self, byKey: "id", value: id)?.update(by: model)
        }
    }
    
    public func makeMain(forId id: String) {
        execute { realm in
            realm.objects(DCard.self).forEach { card in
                card.set(isMain: false)
            }
            
            realm.object(ofType: DCard.self, forPrimaryKey: id)?.set(isMain: true)
        }
    }
}
