//
//  TabDataService.swift
//  YuzPay
//
//  Created by applebro on 21/02/23.
//

import Foundation
import RealmSwift
import YuzSDK

protocol TabDataServiceProtocol {
    func loadMerchants() async -> Bool
    func loadUserEntity() async -> Bool
    func loadSessions() async -> Bool
    func loadExchangeRates() async
    
    func loadInvoices()
}

struct TabDataService: TabDataServiceProtocol {
    func loadUserEntity() async -> Bool {
        guard let entity = await UserNetworkService.shared.getUserInfo() else {
            return false
        }

        Realm.new?.trySafeWrite({
            Realm.new?.add(DUserInfo.init(id: UserSettings.shared.currentUserLocalId, res: entity), update: .modified)
        })
        return true
    }
    
    func loadMerchants() async -> Bool {
        let result = await MainNetworkService.shared.syncMerchantCategories()
        
        return result
    }
    
    func loadSessions() async -> Bool {
        let result = await UserNetworkService.shared.getUserSession()
        
        return result
    }
    
    func loadExchangeRates() async {
        await MainNetworkService.shared.syncExchangeRate()
    }
    
    func loadInvoices() {
        MainNetworkService.shared.syncInvoiceList()
    }
}
