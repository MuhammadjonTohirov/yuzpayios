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
    
    @Persisted var items = List<DMerchant>()
    
    init(id: Int, title: String, order: Int) {
        self.title = title
        self.order = order
        super.init()
        
        self.id = id
    }
    
    override init() {
        super.init()
    }
    
    func add(item: MerchantItemModel) {
        if let ditem = realm?.object(ofType: DMerchant.self, forPrimaryKey: item.id) {
            ditem.update(withModel: item)
            return
        }
        
        items.append(.init(id: item.id, title: item.title, icon: item.icon, type: title))
    }
}

extension DMerchantCategory {
    static func createWith(model: NetResMerchantCategoryItem) -> DMerchantCategory {
        .init(id: model.id, title: model.title, order: model.order)
    }
}
