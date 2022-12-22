//
//  PaymentCategoryManager.swift
//  YuzPay
//
//  Created by applebro on 21/12/22.
//

import Foundation
import RealmSwift

final class PaymentCategoryManager: DManager {
    typealias Obj = PaymentCategoryModel
    
    func add(_ items: PaymentCategoryModel...) {
        execute { realm in
            items.forEach { item in
                realm.add(DPaymentCategory.build(withModel: item), update: .modified)
            }
        }
    }
}
