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
    
    func loadMerchants() async -> Bool {
        let result = await MainNetworkService.shared.syncMerchantCategories()
        
        return result
    }
}
