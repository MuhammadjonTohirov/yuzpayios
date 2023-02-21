//
//  SettingsViewModel.swift
//  YuzPay
//
//  Created by applebro on 17/02/23.
//

import Foundation

class SettingsViewModel: ObservableObject {
    @Published var logout: Bool = false
    
    @Published var showChangePin = false
    @Published var showChangeLang = false
    @Published var showAlert = false

    func showPin() {
        showChangePin = true
    }
    
    func showChangeLanguage() {
        showChangeLang = true
    }
    
    func hideChangeLanguage() {
        showChangeLang = false
    }
    
    func showDeleteAccountAlert() {
        showAlert = true
    }
    
    func deleteAccount() {
        Task {
            let isDeleted = await UserNetworkService.shared.deleteAccount()
            if isDeleted {
                UserSettings.shared.clearUserDetails()
                mainRouter?.navigate(to: .auth)
            } else {
                Logging.l("Cannot delete account")
            }
        }
    }
}
