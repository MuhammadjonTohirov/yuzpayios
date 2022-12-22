//
//  PhoneAuthViewModel.swift
//  YuzPay
//
//  Created by applebro on 17/12/22.
//

import Foundation
import SwiftUI

enum PhoneAuthRoute: ScreenRoute, Identifiable, Hashable {
    var id: String {
        switch self {
        case .uploadPhoto:
            return "uploadPhoto"
        }
    }
    
    case uploadPhoto(model: UploadAvatarViewModel)
    
    @ViewBuilder var screen: some View {
        switch self {
        case let .uploadPhoto(model):
            UploadAvatarView(viewModel: model)
        }
    }
    
    static func == (lhs: PhoneAuthRoute, rhs: PhoneAuthRoute) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum PhoneAuthRoutePopup: ScreenRoute, Identifiable, Hashable {
    var id: String {
        switch self {
        case .otp:
            return "otp"
        }
    }
    
    case otp(model: OtpViewModel)
    
    @ViewBuilder var screen: some View {
        switch self {
        case let .otp(model):
            OTPView(viewModel: model)
        }
    }
    
    static func == (lhs: PhoneAuthRoutePopup, rhs: PhoneAuthRoutePopup) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

final class PhoneAuthViewModel: NSObject, ObservableObject {
    let formViewModel = PhoneAuthFormViewModel()
    @Published var isButtonEnabled: Bool = false
    @Published var route: PhoneAuthRoute?
    @Published var routePopup: PhoneAuthRoutePopup?
    
    func onAppear() {
        formViewModel.onValidityChanged = { [weak self] isOK in
            self?.isButtonEnabled = isOK
        }
    }
    
    func onClickNext() {
        let number = formViewModel.phoneNumber
        let model = OtpViewModel(number: "+998 \(number)")
        model.delegate = self
        routePopup = .otp(model: model)
    }
    
    func onSuccessOtp() {
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
