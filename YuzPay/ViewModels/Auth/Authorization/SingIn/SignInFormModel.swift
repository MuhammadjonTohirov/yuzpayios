//
//  SignInFormModel.swift
//  YuzPay
//
//  Created by applebro on 09/12/22.
//

import Foundation
import SwiftUI

final class SignInFormModel: ObservableObject {
    @Published var login: String = ""
    @Published var password: String = ""
    var onSubmitLogin: (() -> Void)?
    var onSubmitPassword: (() -> Void)?
    
    init(login: String = "", password: String = "") {
        self.login = login
        self.password = password
    }
}
