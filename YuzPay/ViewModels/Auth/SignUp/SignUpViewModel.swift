//
//  SignUpViewModel.swift
//  YuzPay
//
//  Created by applebro on 11/12/22.
//

import Foundation
import SwiftUI

enum AuthRoute: ScreenRoute {
    case otp(_ viewModel: OtpViewModel)
    case faceInfoIntro
    
    @ViewBuilder var screen: some View {
        switch self {
        case let .otp(vm):
            OTPView(viewModel: vm)
        case .faceInfoIntro:
            FacePayStartView()
        }
    }
}

protocol SignUpModelDelegate: NSObject {
    func signUp(model: SignUpViewModel, isSuccess: Bool)
}

extension SignUpModelDelegate {
    func signUp(model: SignUpViewModel, isSuccess: Bool) {}
}

final class SignUpViewModel: NSObject, ObservableObject {
    let formViewModel = SignUpFormViewModel()
    weak var delegate: SignUpModelDelegate?
    @Published var isOfferAccepted = false
    @Published var isSubmitEnabled = false
    @Published var route: AuthRoute?
    
    init(isOfferAccepted: Bool = false, isSubmitEnabled: Bool = false) {
        super.init()
        self.isOfferAccepted = isOfferAccepted
        self.isSubmitEnabled = isSubmitEnabled
        
        formViewModel.onFormStateChanged = { [weak self] _ in
            self?.reloadFormValidation()
        }
    }
    
    var offerIconName: String {
        isOfferAccepted ? "icon_checkbox_on" : "icon_checkbox_off"
    }

    func onClickAcceptOffer() {
        isOfferAccepted.toggle()
        reloadFormValidation()
    }
    
    func reloadFormValidation() {
        isSubmitEnabled = formViewModel.isFormValid && isOfferAccepted
    }
    
    func onClickRegister() {
        let otpViewModel = OtpViewModel()
        otpViewModel.delegate = self
        otpViewModel.number = "+998 \(formViewModel.login.replacingOccurrences(of: "+998", with: ""))"
        route = .otp(otpViewModel)
    }
}

extension SignUpViewModel: OtpModelDelegate {
    func otp(model: OtpViewModel, isSuccess: Bool) {
        if isSuccess {
            route = nil
        }

        let shouldRegisterPassport = !UserSettings.shared.isFillUserDetailsSkipped! && UserSettings.shared.userInfoDetails == nil
        
        if shouldRegisterPassport {
            route = .faceInfoIntro
        } else {
            self.delegate?.signUp(model: self, isSuccess: isSuccess)
        }
    }
}
