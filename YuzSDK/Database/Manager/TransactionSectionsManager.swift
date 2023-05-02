//
//  TransactionsManager.swift
//  YuzPay
//
//  Created by applebro on 01/01/23.
//

import Foundation
import RealmSwift

final class TransactionSectionsManager: DManager {
    typealias Obj = TransactionSection
    
    func add(_ items: TransactionSection...) {
        execute { realm in
            items.forEach({
                realm.add(DTransactionSection(date: $0.date), update: .modified)
            })
        }
    }
    
    var all: Results<DTransactionSection>? {
        Realm.new?.objects(DTransactionSection.self)
    }
}
