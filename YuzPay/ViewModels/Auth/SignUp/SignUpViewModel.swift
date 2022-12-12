//
//  SignUpViewModel.swift
//  YuzPay
//
//  Created by applebro on 11/12/22.
//

import Foundation

final class SignUpViewModel: ObservableObject {
    let formViewModel = SignUpFormViewModel()
    @Published var isOfferAccepted = false
    @Published var isSubmitEnabled = false
    
    init(isOfferAccepted: Bool = false, isSubmitEnabled: Bool = false) {
        self.isOfferAccepted = isOfferAccepted
        self.isSubmitEnabled = isSubmitEnabled
        
        formViewModel.onFormStateChanged = { [weak self] _ in
            self?.reloadFormValidation()
        }
    }
    
    var offerIconName: String {
        isOfferAccepted ? "icon_checkbox_on" : "icon_checkbox_off"
    }

    func onClickAcceptOffer() {
        isOfferAccepted.toggle()
        reloadFormValidation()
    }
    
    func reloadFormValidation() {
        isSubmitEnabled = formViewModel.isFormValid && isOfferAccepted
    }
}
