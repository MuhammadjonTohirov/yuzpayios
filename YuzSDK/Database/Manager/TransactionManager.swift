//
//  TransactionManager.swift
//  YuzPay
//
//  Created by applebro on 02/01/23.
//

import Foundation
import RealmSwift

final class TransactionsManager: DManager {
    typealias Obj = TransactionItem
    
    func add<T>(_ items: T...) where T : ModelProtocol {
        guard let realm = Realm.new else {
            return
        }
        
        items.forEach { tr in
            if let tr = tr as? Obj {
                let sectionPk = DTransactionSection.primaryBy(date: tr.dateTime)
                
                var section = realm.object(ofType: DTransactionSection.self, forPrimaryKey: sectionPk)
                if section == nil {
                    section = DTransactionSection(date: tr.dateTime)
                    realm.trySafeWrite {
                        realm.add(section!, update: .modified)
                    }
                }
                
                realm.trySafeWrite {
                    section?.add(item: .init(tr))
                }
            }
        }
    }
 
    var all: Results<DTransactionItem>? {
        Realm.new?.objects(DTransactionItem.self)
    }
}
