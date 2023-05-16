//
//  CommonDbManager.swift
//  YuzSDK
//
//  Created by applebro on 16/05/23.
//

import Foundation
import RealmSwift

struct CommonDbManager {
    static let shared = CommonDbManager()
    
    func insertExchangeRates(_ rates: [NetResExchangeRate]) {
        Realm.asyncNewSafe { realm in
            let objs = rates.map { rate in
                DExchangeRate.create(with: rate)
            }
            
            realm.trySafeWrite {
                realm.add(objs, update: .modified)
            }
        }
    }
}
