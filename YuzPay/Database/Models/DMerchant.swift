//
//  DPaymentItemModel.swift
//  YuzPay
//
//  Created by applebro on 21/12/22.
//

import Foundation
import RealmSwift

final class DMerchant: Object, DItemProtocol, PaymentServiceProtocol {

    @Persisted(primaryKey: true) var id: String
    
    @Persisted var title: String
    
    @Persisted var icon: String

    @Persisted var type: String
    
    var category: DMerchantCategory? {
        self.realm?.object(ofType: DMerchantCategory.self, forPrimaryKey: type)
    }
    
    init(id: String, title: String, icon: String, type: String) {
        self.title = title
        self.icon = icon
        self.type = type
        super.init()
        self.id = id
    }

    override init() {
        super.init()
    }
}

extension DMerchant {
    static func build(withModel model: MerchantItemModel) -> any DItemProtocol {
        DMerchant.init(id: model.id, title: model.title, icon: model.icon, type: model.type)
    }
    
    public func update(withModel model: MerchantItemModel) {
        self.title = model.title
        self.icon = model.icon
    }
}
