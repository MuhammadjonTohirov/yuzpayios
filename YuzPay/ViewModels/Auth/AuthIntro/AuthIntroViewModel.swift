//
//  AuthIntroViewModel.swift
//  YuzPay
//
//  Created by applebro on 13/12/22.
//

import Foundation
import SwiftUI

protocol ScreenRoute: Hashable, Identifiable {
    associatedtype Content: View
    var screen: Content {get}
}

enum AuthIntroRouter: Hashable, ScreenRoute {
    static func == (lhs: AuthIntroRouter, rhs: AuthIntroRouter) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: String {
        switch self {
        case .login:
            return "login"
        case .register:
            return "register"
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    case register(viewModel: SignUpViewModel)
    case login(viewModel: SignInViewModel)
     
    @ViewBuilder var screen: some View {
        switch self {
        case .register(let viewModel):
            AuthSignUp(viewModel: viewModel)
        case .login:
            AuthSignIn()
        }
    }
}

final class AuthIntroViewModel: NSObject, ObservableObject {
    @Published var route: AuthIntroRouter?
    
    init(route: AuthIntroRouter? = nil) {
        self.route = route
    }
    
    func showRegister() {
        let model = SignUpViewModel()
        model.delegate = self
        route = .register(viewModel: model)
    }
    
    func showLogin() {
        let model = SignInViewModel()

        route = .login(viewModel: model)
    }
}

extension AuthIntroViewModel: SignUpModelDelegate {
    func signUp(model: SignUpViewModel, isSuccess: Bool) {
        if isSuccess {
            route = nil
        }
    }
}
