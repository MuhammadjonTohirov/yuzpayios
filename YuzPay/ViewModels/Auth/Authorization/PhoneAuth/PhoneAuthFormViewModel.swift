//
//  PhoneAuthFormViewModel.swift
//  YuzPay
//
//  Created by applebro on 17/12/22.
//

import Foundation

final class PhoneAuthFormViewModel: ObservableObject {
    @Published var phoneNumber: String = ""
    @Published var isOfferAccepted: Bool = false
    
    var onValidityChanged: ((Bool) -> Void)?
    var offerIconName: String {
        isOfferAccepted ? "icon_checkbox_on" : "icon_checkbox_off"
    }
    
    var isValidForm: Bool = false
    
    func toggleOffer() {
        isOfferAccepted.toggle()
    }
    
    func validateForm() {
        let newValidity = !phoneNumber.isEmpty && isOfferAccepted
        let isChanged = isValidForm != newValidity
        isValidForm = newValidity
        
        isChanged ? onValidityChanged?(isValidForm) : ()
    }
}
