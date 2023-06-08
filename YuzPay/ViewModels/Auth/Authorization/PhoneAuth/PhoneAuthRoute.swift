//
//  PhoneAuthRoute.swift
//  YuzPay
//
//  Created by applebro on 15/02/23.
//

import Foundation
import SwiftUI

enum PhoneAuthRoute: ScreenRoute, Identifiable, Hashable {
    var id: String {
        switch self {
        case .uploadPhoto:
            return "uploadPhoto"
        case .setupPin:
            return "pinSetup"
        }
    }
    
    case uploadPhoto(model: UploadAvatarViewModel)
    case setupPin(model: PinCodeViewModel)
    
    @ViewBuilder var screen: some View {
        switch self {
        case let .uploadPhoto(model):
            UploadAvatarView(viewModel: model)
        case let .setupPin(model):
            PinCodeView(viewModel: model)
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
