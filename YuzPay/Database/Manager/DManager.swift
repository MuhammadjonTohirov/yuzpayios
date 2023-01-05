//
//  DManager.swift
//  YuzPay
//
//  Created by applebro on 21/12/22.
//

import Foundation
import RealmSwift

protocol DManager {
    associatedtype Obj = DItemProtocol
    func add(_ items: Obj...)
    func removeAll()
    func execute(completion: @escaping (Realm) -> Void)
}

extension DManager {
    func execute(completion: @escaping (Realm) -> Void) {
        DataBase.writeThread.async {
            guard let r = Realm.new else {
                return
            }

            r.trySafeWrite {
                completion(r)
            }
        }
    }
    
    func add(_ items: Obj...) {
        fatalError("not implemented yet")
    }
    
    func removeAll() {
        fatalError("not implemented yet")
    }
}
