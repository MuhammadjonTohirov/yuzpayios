//
//  KeyboardKey.swift
//  YuzPay
//
//  Created by applebro on 10/12/22.
//

import Foundation
import SwiftUI

enum Key: Int {
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    case seven = 7
    case eight = 8
    case nine = 9
    case zero = 0
    case clear = 10
    case backSpace = 11
    
    @ViewBuilder var view: some View {
        switch self {
        case .clear:
            Text("C")
        case .backSpace:
            Image("icon_back_space")
                .renderingMode(.template)
                .foregroundColor(Color("dark_gray"))
        default:
            Text("\(self.rawValue)")
        }
    }
}
