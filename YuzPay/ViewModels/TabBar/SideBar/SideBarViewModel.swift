//
//  SideBarViewModel.swift
//  YuzPay
//
//  Created by applebro on 18/12/22.
//

import Foundation

enum SideBarRoute {
    case close
    case identify
    case cards
}

protocol SideBarDelegate: NSObject {
    func sideBar(sideBar: SideBarViewModel, onClick route: SideBarRoute)
}

final class SideBarViewModel: ObservableObject {
    @Published var menus: [SideBarMenuItem] = [
        .payment,
        .transfer,
        .cardsAndWallets,
        .orderCard,
        .issuedInvoices,
        .monitoring,
        .autopayment
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
        case .orderCard:
            break
        case .issuedInvoices:
            break
        case .monitoring:
            break
        case .autopayment:
            break
        }
    }
}
