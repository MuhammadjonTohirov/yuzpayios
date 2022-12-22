//
//  CreditCardMock.swift
//  YuzPay
//
//  Created by applebro on 21/12/22.
//

import Foundation
import RealmSwift

struct MockData {
    static let shared = MockData()
    
    func initMockData() {
        createMockCards()
        createPaymentCategories()
    }
    
    func createMockCards() {
        CreditCardManager.shared.add(
            .init(
                id: "0",
                cardNumber: "8600 24•• •••• ••43",
                expirationDate: Date().after(years: 3).after(monthes: 5), name: "My card", isMain: true,
                icon: "icon_uzcard", cardType: .uzcard, status: .active, moneyAmount: 1300000),
            .init(
                id: "1",
                cardNumber: "7213 44•• •••• ••12",
                expirationDate: Date().after(years: 2).after(monthes: 1), name: "My visa card", isMain: false,
                icon: "icon_visa", cardType: .visa, status: .active, moneyAmount: 1300),
            .init(
                id: "2",
                cardNumber: "9984 71•• •••• ••74",
                expirationDate: Date().after(years: 5).after(monthes: 3), name: "Master card", isMain: false,
                icon: "icon_master", cardType: .master, status: .active, moneyAmount: 40)
        )
        
    }
    
    func createPaymentCategories() {
        PaymentCategoryManager.init().add(
            .init(id: "0", title: "famous", icon: "icon_star"),
            .init(id: "1", title: "mobile_service", icon: "icon_smartphone"),
            .init(id: "2", title: "mobile_service", icon: "icon_wifi"),
            .init(id: "3", title: "tv_service", icon: "icon_tv"),
            .init(id: "4", title: "telephone_service", icon: "icon_phone_2"),
            .init(id: "5", title: "hosting_service", icon: "icon_server")
        )
    }
}
