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
            let isOK = await UserNetworkService.shared.refreshToken()
            
            let hasPin = UserSettings.shared.appPin != nil
            let hasLanguage = UserSettings.shared.language != nil
            
            DispatchQueue.main.async {
                
                if !isOK {
                    mainRouter?.navigate(to: .auth)
                    return
                }
                
                if hasPin {
                    mainRouter?.navigate(to: .pin)
                } else {
                    if hasLanguage {
                        mainRouter?.navigate(to: .auth)
                    } else {
                        mainRouter?.navigate(to: .intro)
                    }
                }
            }
        }
    }
    
    static func createModel() -> LoadingViewModelProtocol {
        LoadingViewModel()
    }
}
