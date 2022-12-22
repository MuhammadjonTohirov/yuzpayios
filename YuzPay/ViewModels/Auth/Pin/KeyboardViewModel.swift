//
//  KeyboardViewModel.swift
//  YuzPay
//
//  Created by applebro on 19/12/22.
//

import Foundation

enum KeyboardType {
    case withClear
    case withExit
    
    var text: String {
        switch self {
        case .withClear:
            return "c".uppercased()
        case .withExit:
            return "exit".localize.uppercased()
        }
    }
}

final class KeyboardViewModel: ObservableObject {
    let type: KeyboardType
    var maxCharacters: Int = 4
    
    init(type: KeyboardType, maxCharacters: Int = 4) {
        self.type = type
        self.maxCharacters = maxCharacters
    }
}
