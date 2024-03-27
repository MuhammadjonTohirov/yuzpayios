//
//  SignUpFormViewModel.swift
//  YuzPay
//
//  Created by applebro on 11/12/22.
//

import Foundation

final class SignUpFormViewModel: ObservableObject {
    @Published var login: String = ""
    @Published var password: String = "test"
    @Published var passwordRepeate: String = "test"
    
    var onFormStateChanged: ((Bool) -> Void)?
    
    var isFormValid = false
    
    func checkFormValidity() {
        
        isFormValid = !login.isEmpty && !password.isEmpty && password == passwordRepeate
        
        onFormStateChanged?(isFormValid)
    }
}
