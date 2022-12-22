//
//  DPaymentItemModel.swift
//  YuzPay
//
//  Created by applebro on 21/12/22.
//

import Foundation
import RealmSwift

final class DPaymentService: Object, DItemProtocol, PaymentServiceProtocol {

    @Persisted(primaryKey: true) var id: String
    
    @Persisted var title: String
    
    @Persisted var icon: String
    
    @Persisted var type: String

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

extension DPaymentService {
    static func build(withModel model: PaymentServiceModel) -> any DItemProtocol {
        DPaymentService.init(id: model.id, title: model.title, icon: model.icon, type: model.type)
    }
}
