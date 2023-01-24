//
//  PaymentItemManager.swift
//  YuzPay
//
//  Created by applebro on 21/12/22.
//

import Foundation
import RealmSwift

final class MerchantManager: DManager {
    typealias Obj = MerchantItemModel
    
    func add(_ items: MerchantItemModel...) {
        execute { realm in
            items.forEach { item in
                let merchant = realm.object(ofType: DMerchantCategory.self, forPrimaryKey: item.type) ?? DMerchantCategory.init(title: item.type)
                
                realm.add(merchant, update: .modified)
                merchant.add(item: item)
            }
        }
    }
}
