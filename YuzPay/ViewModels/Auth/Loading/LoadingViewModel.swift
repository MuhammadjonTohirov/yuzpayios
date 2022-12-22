//
//  LoadingViewModel.swift
//  YuzPay
//
//  Created by applebro on 19/12/22.
//

import Foundation

protocol LoadingViewModelProtocol {
    func initialize()
    
    static func createModel() -> LoadingViewModelProtocol
}

final class LoadingViewModel: LoadingViewModelProtocol {
    func initialize() {
        // this method needs to be modified
        let hasPin = UserSettings.shared.appPin != nil
        
        if hasPin {
            mainRouter?.navigate(to: .pin)
        } else {
            mainRouter?.navigate(to: .intro)
        }
    }
    
    static func createModel() -> LoadingViewModelProtocol {
        LoadingViewModel()
    }
}
