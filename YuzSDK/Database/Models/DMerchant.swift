//
//  DPaymentItemModel.swift
//  YuzPay
//
//  Created by applebro on 21/12/22.
//

import Foundation
import RealmSwift

final public class DMerchant: Object, DItemProtocol, Identifiable, PaymentServiceProtocol {

    @Persisted(primaryKey: true) public var id: String
    
    @Persisted public var title: String
    
    @Persisted public var icon: String

    @Persisted public var categoryId: Int
    
    public var category: DMerchantCategory? {
        self.realm?.object(ofType: DMerchantCategory.self, forPrimaryKey: categoryId)
    }
    
    public init(id: String, title: String, icon: String, category: Int) {
        self.title = title
        self.icon = icon
        self.categoryId = category
        super.init()
        self.id = id
    }

    public override init() {
        super.init()
    }
}

public extension DMerchant {
    static func build(withModel model: MerchantItemModel) -> any DItemProtocol {
        DMerchant.init(id: model.id, title: model.title, icon: model.icon, category: model.categoryId)
    }
    
    func update(withModel model: MerchantItemModel) {
        self.title = model.title
        self.icon = model.icon
    }
}
