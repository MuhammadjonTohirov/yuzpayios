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
    case payment
    case transfer
    case invoices
    case profile
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
            delegate?.sideBar(sideBar: self, onClick: .payment)
        case .transfer:
            delegate?.sideBar(sideBar: self, onClick: .transfer)
        case .cardsAndWallets:
            delegate?.sideBar(sideBar: self, onClick: .cards)
        case .orderCard, .autopayment:
            break
        case .issuedInvoices:
            delegate?.sideBar(sideBar: self, onClick: .invoices)
        case .monitoring:
            delegate?.sideBar(sideBar: self, onClick: .monitoring)
        }
    }
    
    func onClickIdentify() {
        delegate?.sideBar(sideBar: self, onClick: .identify)
    }
    
    func onClickProfile() {
        delegate?.sideBar(sideBar: self, onClick: .profile)
    }
}
