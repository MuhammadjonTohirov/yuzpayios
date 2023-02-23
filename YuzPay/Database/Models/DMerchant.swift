//
//  DPaymentItemModel.swift
//  YuzPay
//
//  Created by applebro on 21/12/22.
//

import Foundation
import RealmSwift

final class DMerchant: Object, DItemProtocol, Identifiable, PaymentServiceProtocol {

    @Persisted(primaryKey: true) var id: String
    
    @Persisted var title: String
    
    @Persisted var icon: String

    @Persisted var categoryId: Int
    
    var category: DMerchantCategory? {
        self.realm?.object(ofType: DMerchantCategory.self, forPrimaryKey: id)
    }
    
    init(id: String, title: String, icon: String, category: Int) {
        self.title = title
        self.icon = icon
        self.categoryId = category
        super.init()
        self.id = id
    }

    override init() {
        super.init()
    }
}

extension DMerchant {
    static func build(withModel model: MerchantItemModel) -> any DItemProtocol {
        DMerchant.init(id: model.id, title: model.title, icon: model.icon, category: model.categoryId)
    }
    
    public func update(withModel model: MerchantItemModel) {
        self.title = model.title
        self.icon = model.icon
    }
}
