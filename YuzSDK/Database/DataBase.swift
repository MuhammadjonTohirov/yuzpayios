//
//  DataBase.swift
//  YuzPay
//
//  Created by applebro on 21/12/22.
//

import Foundation
import RealmSwift

public class DataBase {
    public static let writeThread = DispatchQueue(label: "databaseWrite", qos: .utility)
    
    public static var shouldLoadPrerequisites: Bool {
        return !hasMerchantCategories && !hasUserInfo
    }
    
    public static var hasMerchantCategories: Bool {
        !(Realm.new?.objects(DMerchantCategory.self).isEmpty ?? true)
    }
    
    public static func clear() {
        Realm.asyncNewSafe { realm in
            realm.trySafeWrite {
                realm.deleteAll()
            }
        }
    }
    
    public static var hasUserInfo: Bool {
        guard let number = UserSettings.shared.userPhone else {
            return false
        }

        return Realm.new?.objects(DUserInfo.self).filter("phoneNumber = %@", number).first != nil
    }
    
    public static var userInfo: DUserInfo? {
        guard let number = UserSettings.shared.userPhone else {
            return nil
        }
        
        return Realm.new?.objects(DUserInfo.self).filter("phoneNumber = %@", number).first
    }
    
    public static var usdRate: DExchangeRate? {
        return Realm.new?.objects(DExchangeRate.self).first(where: {$0.currencyID == .usd})
    }
    
    public static func writeNotifications(_ notifications: [NetResBodyUserLog]) {
        writeThread.async {
            Realm.asyncNewSafe { realm in
                realm.trySafeWrite {
                    realm.add(notifications.map({DNotification(res: $0)}), update: .modified)
                }
            }
        }
    }
}

extension DNotification {
    convenience init(res: NetResBodyUserLog) {
        self.init(logID: res.logID, logTitle: res.logTitle, createdDate: res.createdDate, logStatus: res.logStatus, logDetails: res.logDetails, userID: res.userID)
    }
}
