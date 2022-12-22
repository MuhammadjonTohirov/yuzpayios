//
//  InitLoginViewModel.swift
//  YuzPay
//
//  Created by applebro on 18/12/22.
//

import Foundation

final class SelectLanguageViewModel: ObservableObject {
    @Published var selectedLanguage: Language = (UserSettings.shared.language ?? .uzbek) {
        didSet {
            UserSettings.shared.language = selectedLanguage
        }
    }
    
    func select(language: Language) {
        self.selectedLanguage = language
    }
    
    func onClickNext() {
        mainRouter?.navigate(to: .auth)
    }
}
