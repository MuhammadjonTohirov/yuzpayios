//
//  LoadingViewModel.swift
//  YuzPay
//
//  Created by applebro on 19/12/22.
//

import Foundation
import YuzSDK

protocol LoadingViewModelProtocol {
    func initialize()
    
    static func createModel() -> LoadingViewModelProtocol
}

final class LoadingViewModel: LoadingViewModelProtocol {
    func initialize() {
        Task(priority: .high) {
            let isOK = await UserNetworkService.shared.refreshTokenIfNeeded()
            
            let hasPin = UserSettings.shared.appPin != nil
            let hasLanguage = UserSettings.shared.language != nil
            
            DispatchQueue.main.async {
                if !hasLanguage {
                    mainRouter?.navigate(to: .intro)
                    return
                }
                
                if !isOK {
                    mainRouter?.navigate(to: .auth)
                    return
                }
                
                if hasPin {
                    mainRouter?.navigate(to: .pin)
                } else {
                    mainRouter?.navigate(to: .auth)
                }
            }
        }
    }
    
    static func createModel() -> LoadingViewModelProtocol {
        LoadingViewModel()
    }
}
