//
//  PinCodeViewModel.swift
//  YuzPay
//
//  Created by applebro on 10/12/22.
//

import Foundation

class PinCodeViewModel: ObservableObject {
    @Published var pin: String = ""
    var title: String = "Введите PIN-код"
    private var pin1: String = ""
    let maxCharacters: Int = 4
    private var pin2: String = ""
    
    @Published var isConfirmed: Bool = false
    
    func onEditingPin() {
        let isEditing = pin.count < maxCharacters
        let isFilled = pin.count == maxCharacters
        
        let isEditingPin1 = pin1.count < maxCharacters && isEditing
        let isEditingPin2 = pin2.count < maxCharacters && isEditing
                
        if isFilled {
            if pin1.isEmpty {
                pin1 = pin
                
                title = "Повторите\nPIN-код"
                pin = ""
                return
            }
            
            if pin2.isEmpty {
                pin2 = pin
                
                isConfirmed = pin1 == pin2
            }
            
            if isConfirmed {
                // finish pin
                
                return
            }
            
            pin1 = ""
            pin2 = ""
            pin = ""
            title = "Введите PIN-код"
        } else {
            isConfirmed = !(isEditingPin1 || isEditingPin2)
        }
    }
}
