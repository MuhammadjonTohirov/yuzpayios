//
//  MainAlertModel.swift
//  YuzPay
//
//  Created by applebro on 22/04/23.
//

import Foundation

final class MainAlertModel: ObservableObject {
    @Published var alert: Bool = false
    var title: String = ""
    var message: String = ""
    
    func show(title: String, message: String) {
        self.title = title
        self.message = message
        self.alert = true
    }
}
