//
//  DataBase.swift
//  YuzPay
//
//  Created by applebro on 21/12/22.
//

import Foundation
import RealmSwift

class DataBase {
    static let writeThread = DispatchQueue(label: "databaseWrite", qos: .background)
    
    static var shouldLoadPrerequisites: Bool {
        guard let number = UserSettings.shared.userPhone else {
            return true
        }
        
        return Realm.new?.object(ofType: DUserInfo.self, forPrimaryKey: number) == nil
    }
}
