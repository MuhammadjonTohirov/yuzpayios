//
//  PaymentItemManager.swift
//  YuzPay
//
//  Created by applebro on 21/12/22.
//

import Foundation
import RealmSwift

struct MerchantManager: DManager {
    typealias Obj = MerchantItemModel
        
    func add<T>(_ items: T...) where T : ModelProtocol {
        execute { realm in
            items.forEach { _merchant in
                if let merchant = _merchant as? MerchantItemModel {
                    realm.add(DMerchant.build(withModel: merchant), update: .modified)
                }
            }
        }
    }
    
    func addAll<T>(_ items: [T]) where T : ModelProtocol {
        execute { realm in
            let objs = items.compactMap({DMerchant.build(withModel: $0 as!MerchantItemModel)})
            realm.add(objs, update: .modified)
        }
    }
    
    var all: Results<DMerchant>? {
        Realm.new?.objects(DMerchant.self)
    }
}


