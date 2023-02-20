//
//  SignUpViewModel.swift
//  YuzPay
//
//  Created by applebro on 11/12/22.
//

import Foundation
import SwiftUI

enum AuthRoute: Hashable, ScreenRoute {
    static func == (lhs: AuthRoute, rhs: AuthRoute) -> Bool {
        lhs.id == rhs.id
    }

    var id: String {
        switch self {
        case .otp:
            return "cards"
        case .faceInfoIntro:
            return "faceid"
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
        
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
        let otpViewModel = OtpViewModel(
            number: formViewModel.login
                .replacingOccurrences(of: "+998", with: "")
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "-", with: ""),
            countryCode: "+998")
        otpViewModel.delegate = self
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
