//
//  DPaymentCategory.swift
//  YuzPay
//
//  Created by applebro on 21/12/22.
//

import Foundation
import RealmSwift

final class DPaymentCategory: Object, DItemProtocol, PaymentCategoryProtocol {
    
    @Persisted(primaryKey: true) var id: String
    
    @Persisted var title: String
    
    @Persisted var icon: String
    
    init(id: String, title: String, icon: String) {
        self.title = title
        self.icon = icon
        
        super.init()
        
        self.id = id
    }
    
    
    override init() {
        super.init()
    }
}

extension DPaymentCategory {
    static func build(withModel model: PaymentCategoryModel) -> any DItemProtocol {
        DPaymentCategory.init(id: model.id, title: model.title, icon: model.icon)
    }
}
