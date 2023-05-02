//
//  InvoiceManager.swift
//  YuzPay
//
//  Created by applebro on 24/03/23.
//

import Foundation
import RealmSwift

final class InvoiceManager: DManager {
    typealias DModel = DInvoiceItem
    typealias Obj = NetResInvoiceItem

    var all: Results<DInvoiceItem>? {
        Realm.new?.objects(DInvoiceItem.self)
    }
    
    func add<T>(_ items: T...) where T : ModelProtocol {
        Realm.asyncNew { result in
            switch result {
            case .success(let realm):
                items.forEach { _item in
                    if let item = _item as? InvoiceItemModel {
                        realm.trySafeWrite {
                            realm.add(DInvoiceItem.build(withModel: item), update: .modified)
                        }
                    }
                }
            case .failure(let failure):
                Logging.l(tag: "InvoiceManager", "Cannot insert \(failure.localizedDescription)")
            }
        }
    }
    
    func addAll<T>(_ items: [T]) where T : ModelProtocol {
        Realm.asyncNew { result in
            switch result {
            case .success(let realm):
                items.forEach { _item in
                    if let item = _item as? InvoiceItemModel {
                        realm.trySafeWrite {
                            realm.add(DInvoiceItem.build(withModel: item), update: .modified)
                        }
                    }
                }
            case .failure(let failure):
                Logging.l(tag: "InvoiceManager", "Cannot insert \(failure.localizedDescription)")
            }
        }
    }
}
