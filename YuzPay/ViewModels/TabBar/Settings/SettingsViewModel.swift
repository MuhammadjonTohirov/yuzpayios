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
    
    var deleteAccountResult: NetResDeleteAccount?
    var otpModel: OtpViewModel?
    
    @Published var showOTPConfirm = false
    
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
            if let result = await UserNetworkService.shared.deleteAccount() {
                self.deleteAccountResult = result as? NetResDeleteAccount
                DispatchQueue.main.async {
                    self.showDeleteAccountConfirmation()
                }
            }
        }
    }
    
    private func showDeleteAccountConfirmation() {
        otpModel = .init(title: "delete_account".localize, number: UserSettings.shared.userPhone ?? "", countryCode: "+998", maxCounterValue: 120)
        otpModel?.confirmOTP = { [weak self] otp in
            guard let self = self else { return (false, nil) }
            confirmDelete(otp: otp)
            return (deleteAccountResult?.code == otp, nil)
        }
        
        self.showOTPConfirm = true
    }
    
    private func confirmDelete(otp: String) {
        guard let deleteAccountResult else {
            return
        }
        
        Task {
            let isOK = await UserNetworkService.shared.confimDeleteAccount(code: otp, token: deleteAccountResult.token)
         
            if isOK {
                UserSettings.shared.clearUserDetails()
                mainRouter?.navigate(to: .auth)
            }
        }
    }
}
