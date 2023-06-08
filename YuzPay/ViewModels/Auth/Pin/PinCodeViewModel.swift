//
//  PinCodeViewModel.swift
//  YuzPay
//
//  Created by applebro on 10/12/22.
//

import Foundation
import SwiftUI
import YuzSDK

enum PinViewReason: Identifiable, Equatable {
    var id: Int {
        switch self {
        case .login:
            return 0
        case .setup:
            return 1
        case .confirm:
            return 2
        }
    }
    
    case login
    case setup
    case confirm(pin: String)
}

enum PinViewRoute: Hashable, ScreenRoute {
    static func == (lhs: PinViewRoute, rhs: PinViewRoute) -> Bool {
        lhs.id == rhs.id
    }

    var id: String {
        switch self {
        case .confirmWith:
            return "pinConfirm"
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    case confirmWith(code: String, completion: (Bool) -> Void)
    
    var screen: some View {
        switch self {
        case .confirmWith(let code, let completion):
            let model: PinCodeViewModel = .init(title: "confirm_pin".localize, reason: .confirm(pin: code))
            model.onResult = completion
            return PinCodeView(viewModel: model)
        }
    }
}

class PinCodeViewModel: ObservableObject {
    @Published var pin: String = ""

    let reason: PinViewReason
    var title: String = "Введите PIN-код"

    let maxCharacters: Int = 4

    @Published var isButtonEnabled: Bool = false

    var keyboardModel: KeyboardViewModel
    
    var onResult: ((Bool) -> Void)?
    
    @Published var route: PinViewRoute?
    
    init(title: String, reason: PinViewReason, onResult: ((Bool) -> Void)? = nil) {
        self.title = title
        self.reason = reason
        self.onResult = onResult
        
        keyboardModel = .init(type: reason == .login ? .withExit : .withClear)
    }
    
    func onEditingPin() {
        let isFilled = pin.count == maxCharacters
        
        isButtonEnabled = isFilled
        
        if isFilled {
            switch reason {
            case .login:
                if pin == UserSettings.shared.appPin {
                    onSuccessLogin()
                }
            default:
                break
            }
        }
    }
    
    func onSuccessLogin() {
        DispatchQueue.main.async {
            mainRouter?.navigate(to: .main)
        }
    }
    
    func onClickNext() {
        switch reason {
        case .login:
            break
        case .setup:
            route = .confirmWith(code: pin, completion: { [weak self] isOK in
                guard let self else {
                    return
                }
                
                if isOK {
                    self.route = nil
                    UserSettings.shared.appPin = self.pin
                }
                
                self.onResult?(isOK)
            })
        case .confirm(let pin):
            onResult?(pin == self.pin)
        }
    }
}
