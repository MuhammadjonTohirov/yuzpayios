//
//  PhoneAuthViewModel.swift
//  YuzPay
//
//  Created by applebro on 17/12/22.
//

import Foundation
import SwiftUI

final class PhoneAuthViewModel: NSObject, ObservableObject {
    let formViewModel = PhoneAuthFormViewModel()
    @Published var isButtonEnabled: Bool = false
    @Published var route: PhoneAuthRoute? {
        didSet {
            pushToPage = route != nil
        }
    }
    
    @Published var routePopup: PhoneAuthRoutePopup?
    @Published var loading = false
    @Published var pushToPage = false
    private var isUserExists = false
    
    func onAppear() {
        formViewModel.onValidityChanged = { [weak self] isOK in
            self?.isButtonEnabled = isOK
        }        
    }
    
    func onClickNext() {
        checkPhone()
    }
        
    func checkPhone() {
        let number = formViewModel.phoneNumber.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
        guard formViewModel.isValidForm else {return}
        loading = true
        
        Task {
            guard let result = await UserNetworkService().getOTP(forNumber: number), let body = result.data, result.success else {
                return
            }
            
            await MainActor.run {
                self.loading = false
                UserSettings.shared.userPhone = number
                UserSettings.shared.checkPhoneToken = body.token
                UserSettings.shared.lastOTP = body.code

                Logging.l("token \(body.token), isUserExists \(body.exists)")
                
                self.isUserExists = body.exists
                self.onSuccess()
            }
        }
    }
    
    func onSuccess() {
        showOtp()
    }
    
    func onFailure() {
        
    }
    
    func showOtp() {
        let number = formViewModel.phoneNumber
        let model = OtpViewModel(number: number.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: ""), countryCode: "+998")
        model.delegate = self
        routePopup = .otp(model: model)
    }
    
    func onSuccessOtp() {
        if isUserExists {
            getAccessToken()
        } else {
            showUploadAvatar()
        }
    }
    
    private func getAccessToken() {
        self.loading = true
        Task {
            let success = await UserNetworkService.shared.getAccessToken()
            await MainActor.run {
                self.loading = false
                let hasPin = UserSettings.shared.appPin != nil
                if success {
                    hasPin ? showMain() : showPinSetup()
                } else {
                    
                }
            }
        }
    }
    
    private func showMain() {
        mainRouter?.navigate(to: .main)
    }
    
    private func showPinSetup() {
        let model: PinCodeViewModel = .init(title: "setup_pin".localize, reason: .setup)
        model.onResult = { [weak self] isOK in
            
            guard let _ = self else {
                return
            }
            
            if isOK {
                mainRouter?.navigate(to: .main)
            }
        }
        
        route = .setupPin(model: model)
    }
    
    private func showUploadAvatar() {
        let model = UploadAvatarViewModel()
        route = .uploadPhoto(model: model)
    }
}

extension PhoneAuthViewModel: OtpModelDelegate {
    func otp(model: OtpViewModel, isSuccess: Bool) {
        if isSuccess {
            self.routePopup = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.onSuccessOtp()
            }
        }
    }
}
