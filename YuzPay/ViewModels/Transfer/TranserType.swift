//
//  TranserType.swift
//  YuzPay
//
//  Created by applebro on 24/01/23.
//

import Foundation
import SwiftUI

enum TransferType: String, Identifiable, Hashable {
    var id: String {
        self.rawValue
    }
    
    case transferToOther
    case transferToMe
    case exchange
    case transferInternational
    
    var iconName: String {
        switch self {
        case .transferToOther:
            return "icon_card"
        case .transferToMe:
            return "icon_wallet_2"
        case .exchange:
            return "icon_refresh"
        case .transferInternational:
            return "icon_globe"
        }
    }
    
    var title: String {
        switch self {
        case .transferToOther:
            return "transfer_to_card".localize
        case .transferToMe:
            return "transfer_to_me".localize
        case .exchange:
            return "exchange".localize
        case .transferInternational:
            return "transfer_international".localize
        }
    }
    
    func rowButton(onClick: @escaping () -> Void) -> some View {
        RowButton(icon: Image(iconName), text: title, onClick: onClick) {
            AnyView(RightChevron())
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.rawValue)
    }
}
