//
//  Alertable.swift
//  YuzPay
//
//  Created by applebro on 21/02/23.
//

import Foundation

protocol Alertable: NSObject {
    var alert: AlertToast {get set}
    var shouldShowAlert: Bool {get set}
    func showAlert(message: String)
    func showError(message: String)
    
    func showCustomAlert(alert: AlertToast)
}

extension Alertable {
    func showAlert(message: String) {
        DispatchQueue.main.async {
            self.alert = .init(displayMode: .alert, type: .regular, title: message)
            self.shouldShowAlert = true
            SEffect.rigid()
        }
    }
    
    func showError(message: String) {
        DispatchQueue.main.async {
            self.alert = .init(displayMode: .banner(.pop), type: .error(.systemRed), title: message)
            self.shouldShowAlert = true
            SEffect.rigid()
        }
    }
    
    func showCustomAlert(alert: AlertToast) {
        DispatchQueue.main.async {
            self.alert = alert
            self.shouldShowAlert = true
        }
    }
}
