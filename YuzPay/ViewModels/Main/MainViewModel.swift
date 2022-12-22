//
//  MainViewModel.swift
//  YuzPay
//
//  Created by applebro on 13/12/22.
//

import Foundation
import SwiftUI

enum AppDestination: ScreenRoute {
    case intro
    case auth
    case main
    case loading
    case pin
    
    @ViewBuilder var screen: some View {
        switch self {
        case .loading:
            LoadingView(viewModel: LoadingViewModel.createModel())
        case .pin:
            PinCodeView(viewModel: .init(title: "insert_pin".localize, reason: .login))
        case .intro:
            AuthSelectLanguage()
        case .auth:
            PhoneAuthView()
        case .main:
            TabBarView()
        }
    }
}

class MainViewRouter {
    var delegate: AppDelegate?
}

protocol AppDelegate {
    func navigate(to destination: AppDestination)
}

var routerObject = MainViewRouter()
var mainRouter: AppDelegate? = routerObject.delegate

final class MainViewModel: ObservableObject {
    @Published var route: AppDestination = .loading
    
    init(route: AppDestination = .loading) {
        self.route = route
        mainRouter = self
    }
}

extension MainViewModel: AppDelegate {
    func navigate(to destination: AppDestination) {
        route = destination
    }
}
