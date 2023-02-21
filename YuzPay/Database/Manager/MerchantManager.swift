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
            items.forEach { merchant in
                if let category = realm.object(ofType: DMerchantCategory.self, forPrimaryKey: merchant.type) {
                    realm.add(category, update: .modified)
                    category.add(item: merchant)
                }
            }
        }
    }
}


