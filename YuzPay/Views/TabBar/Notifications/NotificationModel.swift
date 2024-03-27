//
//  NotificationType.swift
//  YuzPay
//
//  Created by applebro on 09/01/23.
//

import Foundation
import SwiftUI

enum NotificationType {
    case information
    case technical
    case expirePassport
    case expireCard
    case blockCard
    
    var icon: Image {
        switch self {
        case .information:
            return Image(systemName: "info.circle")
        case .technical:
            return Image(systemName: "exclamationmark.triangle")
        case .expirePassport:
            return Image(systemName: "clock")
        case .expireCard:
            return Image(systemName: "creditcard")
        case .blockCard:
            return Image(systemName: "lock")
        }
    }
}
