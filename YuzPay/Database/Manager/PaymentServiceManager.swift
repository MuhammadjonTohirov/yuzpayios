//
//  PaymentItemManager.swift
//  YuzPay
//
//  Created by applebro on 21/12/22.
//

import Foundation
import RealmSwift

final class PaymentServiceManager: DManager {
    typealias Obj = PaymentServiceModel
    
    func add(_ items: PaymentServiceModel...) {
        execute { realm in
            items.forEach { item in
                realm.add(DPaymentService.build(withModel: item), update: .modified)
            }
        }
    }
}
