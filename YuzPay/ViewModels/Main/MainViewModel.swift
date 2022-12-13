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
    case main
    
    @ViewBuilder var screen: some View {
        switch self {
        case .intro:
            AuthIntroView(viewModel: AuthIntroViewModel())
        case .main:
            Text("MAIN")
        }
    }
}

class MainViewRouter {
    var delegate: AppDelegate?
}

protocol AppDelegate {
    func navigate(to destination: AppDestination)
}


var appDelegate = MainViewRouter().delegate

final class MainViewModel: ObservableObject {
    @Published var route: AppDestination = .intro
    
    init(route: AppDestination = .intro) {
        self.route = route
        
        YuzPay.appDelegate = self
    }
}

extension MainViewModel: AppDelegate {
    func navigate(to destination: AppDestination) {
        route = destination
    }
}
