//
//  SideBarViewModel.swift
//  YuzPay
//
//  Created by applebro on 18/12/22.
//

import Foundation
import SwiftUI
import RealmSwift
import YuzSDK

enum SideMenuItem {
    case close
    case identify
    case cards
    case monitoring
    case payment
    case transfer
    case invoices
    case profile
    case aboutUs
}

protocol SideBarDelegate: NSObject {
    func sideBar(sideBar: SideBarViewModel, onClick route: SideMenuItem)
}

final class SideBarViewModel: ObservableObject {
    private var userInfoToken: NotificationToken?
    @Published var menus: [SideBarMenuItem] = [
        .payment,
        .transfer,
        .cardsAndWallets,
        .issuedInvoices,
        .monitoring,
        .support,
        .aboutUs
    ]
    
    var isVerified = false
    
    weak var delegate: SideBarDelegate?
    
    @Published var username: String = ""
    
    private var isAppeared = false
    
    func onAppear() {
        if !isAppeared {
            subscriberUserInfo()
            isAppeared = true
        }
    }
    
    private func subscriberUserInfo() {
        guard let realm = Realm.new else {
            return
        }
        
        let userModel = realm.object(ofType: DUserInfo.self, forPrimaryKey: UserSettings.shared.currentUserLocalId)
        
        reloadUserInfo(userModel)
        
        userInfoToken = userModel?.observe({[weak self] changeObject in
            switch changeObject {
            case let .change(base, _):
                guard let model = base as? DUserInfo, !(model.isInvalidated) else {
                    return
                }
                
                self?.reloadUserInfo(model)
                
                break
            default:
                break
            }
        })
    }
    
    private func reloadUserInfo(_ info: DUserInfo?) {
        guard let info else {
            return
        }
        
        self.username = info.name ?? ""
        self.isVerified = info.isVerified
    }
    
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
        case .support:
            openTelegramBot()
        case .aboutUs:
            delegate?.sideBar(sideBar: self, onClick: .aboutUs)
        }
    }
    
    private func openTelegramBot() {
        UIApplication.shared.open(URL.telegramBotURL, options: [:], completionHandler: nil)
    }
    
    func onClickIdentify() {
        delegate?.sideBar(sideBar: self, onClick: .identify)
    }
    
    func onClickProfile() {
        delegate?.sideBar(sideBar: self, onClick: .profile)
    }
}
