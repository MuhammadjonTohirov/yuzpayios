//
//  TabDataService.swift
//  YuzPay
//
//  Created by applebro on 21/02/23.
//

import Foundation
import RealmSwift

protocol TabDataServiceProtocol {
    func loadUserInfo() async -> Bool
    func loadMerchants() async -> Bool
    func loadUserEntity() async -> Bool
    func loadSessions() async -> Bool
}

struct TabDataService: TabDataServiceProtocol {
    
    func loadUserInfo() async -> Bool {
        
        guard let userInfo = await UserNetworkService.shared.getUserInfo() else {
            return false
        }
        
        Realm.new?.trySafeWrite({
            Realm.new?.add(DUserInfo.init(id: UserSettings.shared.currentUserLocalId, res: userInfo), update: .modified)
        })
        
        return true
    }
    
    func loadUserEntity() async -> Bool {
        guard let entity = await UserNetworkService.shared.getUserEntity() else {
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
}
