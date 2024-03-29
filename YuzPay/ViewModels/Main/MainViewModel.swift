//
//  MainViewModel.swift
//  YuzPay
//
//  Created by applebro on 13/12/22.
//

import Foundation
import SwiftUI
import YuzSDK

enum AppDestination: Hashable, ScreenRoute {
    static func == (lhs: AppDestination, rhs: AppDestination) -> Bool {
        lhs.id == rhs.id
    }

    var id: String {
        switch self {
        case .intro:
            return "intro"
        case .auth:
            return "auth"
        case .main:
            return "main"
        case .loading:
            return "loading"
        case .pin:
            return "pin"
        case .test:
            return "test"
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    case intro
    case auth
    case main
    case loading
    case pin
    case test
    
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
        case .test:
            NavigationStack {
                UploadAvatarView()
            }
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
        UserSettings.shared.lastActiveDate = Date()
        UserSettings.shared.numberOfOpens = (UserSettings.shared.numberOfOpens ?? 0) + 1
    }
}

extension MainViewModel: AppDelegate {
    func navigate(to destination: AppDestination) {
        DispatchQueue.main.async {
            self.route = destination
        }
    }
}
