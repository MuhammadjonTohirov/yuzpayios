//
//  DPaymentCategory.swift
//  YuzPay
//
//  Created by applebro on 21/12/22.
//

import Foundation
import RealmSwift

class DMerchantCategory: Object, Identifiable {
    var id: String {
        title
    }
    
    @Persisted(primaryKey: true) var title: String
    
    @Persisted var items = List<DMerchant>()
    
    init(title: String) {
        super.init()
        self.title = title
    }
    
    override init() {
        super.init()
    }
    
    func add(item: MerchantItemModel) {
        if let ditem = realm?.object(ofType: DMerchant.self, forPrimaryKey: item.id) {
            realm?.delete(ditem)
        }
        
        items.append(.init(id: item.id, title: item.title, icon: item.icon, type: title))
    }
}
