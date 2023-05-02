//
//  SettingsViewModel.swift
//  YuzPay
//
//  Created by applebro on 17/02/23.
//

import Foundation
import YuzSDK

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
            let _ = await UserNetworkService.shared.deleteAccount()
            UserSettings.shared.clearUserDetails()
            mainRouter?.navigate(to: .auth)
        }
    }
}
