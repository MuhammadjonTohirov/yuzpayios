//
//  AuthSingInViewModel.swift
//  YuzPay
//
//  Created by applebro on 08/12/22.
//

import Foundation
import SwiftUI

public protocol SingInPorotocol {
    func checkFormValidity()
}

enum LoginField: String, Hashable {
    case username
    case password
}

class AuthSingInViewModel: SingInPorotocol, ObservableObject {
    @Published var isFormValid: Bool = false
    public var signInForm: SignInFormModel
    
    init(login: String = "", password: String = "", isFormValid: Bool = false) {
        signInForm = SignInFormModel(login: login, password: password)
        self.isFormValid = isFormValid
        
        print("On Create view model")
        
        signInForm.onSubmitPassword = { [weak self] in
            if let self {
                self.checkFormValidity()
            }
        }
        
        signInForm.onSubmitLogin = { [weak self] in
            if let self {
                self.checkFormValidity()
            }
        }
    }
    
    func checkFormValidity() {
        isFormValid = !signInForm.login.isEmpty && !signInForm.password.isEmpty
    }
}
