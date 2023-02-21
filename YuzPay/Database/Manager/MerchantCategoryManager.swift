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
    
    func add(_ items: NetResMerchantCategoryItem...) {
        execute { realm in
            items.forEach { item in
                let cat = DMerchantCategory.init(id: item.id, title: item.title, order: item.order)
                realm.add(cat, update: .modified)
            }
        }
    }
}

