//
//  DPaymentCategory.swift
//  YuzPay
//
//  Created by applebro on 21/12/22.
//

import Foundation
import RealmSwift

final class DMerchantCategory: Object, Identifiable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String
    @Persisted var order: Int
    
    var merchants: Results<DMerchant>? {
        self.realm?.objects(DMerchant.self).filter("categoryId = %d", id)
    }
 
    init(id: Int, title: String, order: Int) {
        self.title = title
        self.order = order
        super.init()
        
        self.id = id
    }
    
    override init() {
        super.init()
    }
}

extension DMerchantCategory {
    static func createWith(model: NetResMerchantCategoryItem) -> DMerchantCategory {
        .init(id: model.id, title: model.title, order: model.order)
    }
}
