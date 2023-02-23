//
//  DataBase.swift
//  YuzPay
//
//  Created by applebro on 21/12/22.
//

import Foundation
import RealmSwift

class DataBase {
    static let writeThread = DispatchQueue(label: "databaseWrite", qos: .utility)
    
    static var shouldLoadPrerequisites: Bool {
        return !hasMerchantCategories && !hasUserInfo
    }
    
    static var hasMerchantCategories: Bool {
        !(Realm.new?.objects(DMerchantCategory.self).isEmpty ?? true)
    }
    
    static var hasUserInfo: Bool {
        guard let number = UserSettings.shared.userPhone else {
            return false
        }
        
        return Realm.new?.object(ofType: DUserInfo.self, forPrimaryKey: number) != nil
    }
}
