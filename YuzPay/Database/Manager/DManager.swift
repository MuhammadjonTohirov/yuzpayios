//
//  DManager.swift
//  YuzPay
//
//  Created by applebro on 21/12/22.
//

import Foundation
import RealmSwift

protocol DManager {
    associatedtype DModel: Object
    func add<T: ModelProtocol>(_ items: T...)
    func addAll<T: ModelProtocol>(_ items: [T])
    func removeAll()
    func execute(completion: @escaping (Realm) -> Void)
    var all: Results<DModel>? {get}
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
    
    func add<T: ModelProtocol>(_ items: T...) {
        fatalError("not implemented yet")
    }
    
    func removeAll() {
        fatalError("not implemented yet")
    }
    
    func addAll<T: ModelProtocol>(_ items: [T]) {
        fatalError("not implemented yet")
    }
}

class ObjectManager {
    let manager: any DManager
    
    init(_ manager: any DManager) {
        self.manager = manager
    }
    
    func add<T: ModelProtocol>(_ items: T...) {
        items.forEach { item in
            autoreleasepool {
                manager.add(item)
            }
        }
    }
    
    func addAll<T: ModelProtocol>(_ items: [T]) {
        autoreleasepool {
            manager.addAll(items)
        }
    }
}
