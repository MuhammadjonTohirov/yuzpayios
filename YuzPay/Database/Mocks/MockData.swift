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
        clearAll()
        createMockCards()
        createTransactions()
        createMerchants()
    }
    
    func createMockCards() {
        CreditCardManager.shared.add(
            .init(
                id: "0",
                cardNumber: "8600 24•• •••• ••43",
                expirationDate: Date().after(years: 3).after(monthes: 5), name: "My card", holderName: "MUHAMMADJON TOHIROV", isMain: true,
                icon: "icon_uzcard", cardType: .uzcard, status: .active, moneyAmount: 1300000),
            .init(
                id: "1",
                cardNumber: "7213 44•• •••• ••12",
                expirationDate: Date().after(years: 2).after(monthes: 1), name: "My visa card", holderName: "MUHAMMADJON TOHIROV", isMain: false,
                icon: "icon_visa", cardType: .visa, status: .active, moneyAmount: 1300),
            .init(
                id: "2",
                cardNumber: "9984 71•• •••• ••74",
                expirationDate: Date().after(years: 5).after(monthes: 3), name: "Master card", holderName: "MUHAMMADJON TOHIROV", isMain: false,
                icon: "icon_master", cardType: .master, status: .active, moneyAmount: 40)
        )
        
    }
    
    func createMerchants() {
        
    }
    
    func createTransactions() {
        let manager = TransactionsManager()
        
        manager.add(
            .init(id: "123123123", agentName: "Ucell", status: .success, amount: 3000, currency: "sum", dateTime: Date()),
            .init(id: "123123124", agentName: "Ucell", status: .success, amount: 3200, currency: "sum", dateTime: Date()),
            .init(id: "123123125", agentName: "Comnet", status: .success, amount: 100000, currency: "sum", dateTime: Date().after(days: 4))
        )
    }
    
    func removeMockCards() {
        CreditCardManager.shared.removeAll()
    }
    
    func clearAll() {
        Realm.new?.trySafeWrite({
            Realm.new?.deleteAll()
        })
    }
}
