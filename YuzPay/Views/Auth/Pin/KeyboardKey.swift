//
//  KeyboardKey.swift
//  YuzPay
//
//  Created by applebro on 10/12/22.
//

import Foundation
import SwiftUI

enum Key: Identifiable {
    var id: Int {
        switch self {
        case .one:
            return 1
        case .two:
            return 2
        case .three:
            return 3
        case .four:
            return 4
        case .five:
            return 5
        case .six:
            return 6
        case .seven:
            return 7
        case .eight:
            return 8
        case .nine:
            return 9
        case .zero:
            return 0
        case .clear:
            return 10
        case .backSpace:
            return 11
        }
    }
    
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case zero
    case clear(text: String)
    case backSpace
    
    @ViewBuilder var view: some View {
        switch self {
        case .clear(let text):
            Text(text)
                .minimumScaleFactor(0.1)
        case .backSpace:
            Image("icon_back_space")
                .renderingMode(.template)
                .foregroundColor(Color("dark_gray"))
        default:
            Text("\(self.id)")
                .minimumScaleFactor(0.1)
        }
    }
}
