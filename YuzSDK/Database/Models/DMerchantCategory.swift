//
//  DPaymentCategory.swift
//  YuzPay
//
//  Created by applebro on 21/12/22.
//

import Foundation
import RealmSwift

final public class DMerchantCategory: Object, Identifiable {
    @Persisted(primaryKey: true) public var id: Int
    @Persisted public var title: String
    @Persisted public var order: Int
    
    public var merchants: Results<DMerchant>? {
        self.realm?.objects(DMerchant.self).filter("categoryId = %d", id)
    }
 
    public init(id: Int, title: String, order: Int) {
        self.title = title
        self.order = order
        super.init()
        
        self.id = id
    }
    
    public override init() {
        super.init()
    }
}

public extension DMerchantCategory {
    static func createWith(model: NetResMerchantCategoryItem) -> DMerchantCategory {
        .init(id: model.id, title: model.title, order: model.order)
    }
}
