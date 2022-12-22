//
//  SideBarMenuitem.swift
//  YuzPay
//
//  Created by applebro on 18/12/22.
//

import Foundation
import SwiftUI

enum SideBarMenuItem: Identifiable {
    var id: String {
        switch self {
        case .payment:
            return "payment"
        case .transfer:
            return "transfer"
        case .cardsAndWallets:
            return "cardsAndWallets"
        case .orderCard:
            return "orderCard"
        case .issuedInvoices:
            return "issuedInvoices"
        case .monitoring:
            return "monitoring"
        case .autopayment:
            return "autopayment"
        }
    }
    
    case payment
    case transfer
    case cardsAndWallets
    case orderCard
    case issuedInvoices
    case monitoring
    case autopayment
    
    var text: String {
        return id.localize
    }
    
    var iconName: String {
        switch self {
        case .payment:
            return "icon_bucket"
        case .transfer:
            return "icon_transfer"
        case .cardsAndWallets:
            return "icon_card"
        case .orderCard:
            return "icon_card"
        case .issuedInvoices:
            return "icon_document"
        case .monitoring:
            return "icon_monitoring"
        case .autopayment:
            return "icon_clock"
        }
    }
    
    func view(_ onClick: @escaping () -> Void) -> some View {
        Button(action: onClick) {
            HStack(spacing: Padding.default) {
                Image(self.iconName)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 20, height: 20)
                Text(text)
                    .font(.mont(.regular, size: 14))
                Spacer()
                Image(systemName: "chevron.right")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 5, height: 10)
            }
            .foregroundColor(Color("label_color"))
        }
    }
}

struct SideBarMenuItem_Preview: PreviewProvider {
    static var previews: some View {
        SideBarMenuItem.payment.view {
            
        }
    }
}
