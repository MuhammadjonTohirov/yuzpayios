//
//  MerchantCategoryManager.swift
//  YuzPay
//
//  Created by applebro on 21/02/23.
//

import Foundation
import RealmSwift

final class MerchantCategoryManager: DManager {
    typealias Obj = NetResMerchantCategoryItem
    
    static let shared = MerchantCategoryManager()
    
    func add<T>(_ items: T...) where T : ModelProtocol {
        execute { realm in
            items.forEach { item in
                if let _item = item as? NetResMerchantCategoryItem {
                    let cat = DMerchantCategory.init(id: _item.id, title: _item.title, order: _item.order)
                    realm.add(cat, update: .modified)
                }
            }
        }
    }
    
    var all: Results<DMerchantCategory>? {
        Realm.new?.objects(DMerchantCategory.self)
    }
}

