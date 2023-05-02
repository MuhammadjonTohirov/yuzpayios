//
//  UserSessionsManager.swift
//  YuzPay
//
//  Created by applebro on 25/02/23.
//

import Foundation
import RealmSwift

final class UserSessionsManager: DManager {
    typealias Obj = NetResUserSession
    
    func add(_ items: NetResUserSession...) {
        execute { realm in
            items.forEach({
                realm.add(DUserSession.build(withModel: $0), update: .modified)
            })
        }
    }
    
    func addAll<T>(_ items: [T]) where T : ModelProtocol {
        execute { realm in
            let sessions = items.compactMap { i in
                if let item = i as? NetResUserSession {
                    return DUserSession.build(withModel: item)
                }
                return nil
            }
        
            realm.add(sessions, update: .modified)
        }
    }
    
    var all: Results<DUserSession>? {
        Realm.new?.objects(DUserSession.self)
    }
}
