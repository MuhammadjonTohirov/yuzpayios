//
//  SideBarViewModel.swift
//  YuzPay
//
//  Created by applebro on 18/12/22.
//

import Foundation
import SwiftUI

enum SideMenuItem {
    case close
    case identify
    case cards
    case monitoring
}

protocol SideBarDelegate: NSObject {
    func sideBar(sideBar: SideBarViewModel, onClick route: SideMenuItem)
}

final class SideBarViewModel: ObservableObject {
    
    @Published var menus: [SideBarMenuItem] = [
        .payment,
        .transfer,
        .cardsAndWallets,
        .issuedInvoices,
        .monitoring
    ]
    
    weak var delegate: SideBarDelegate?
    
    func onClickClose() {
        delegate?.sideBar(sideBar: self, onClick: .close)
    }
    
    func onClick(menu: SideBarMenuItem) {
        switch menu {
        case .payment:
            break
        case .transfer:
            break
        case .cardsAndWallets:
            delegate?.sideBar(sideBar: self, onClick: .cards)
        case .issuedInvoices, .orderCard:
            break
        case .monitoring:
            delegate?.sideBar(sideBar: self, onClick: .monitoring)
        case .autopayment:
            break
        }
    }
    
    func onClickIdentify() {
        delegate?.sideBar(sideBar: self, onClick: .identify)
    }
}
