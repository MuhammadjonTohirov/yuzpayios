//
//  DManager.swift
//  YuzPay
//
//  Created by applebro on 21/12/22.
//

import Foundation
import RealmSwift

public protocol DManager {
    associatedtype DModel: Object
    func add<T: ModelProtocol>(_ items: T...)
    func addAll<T: ModelProtocol>(_ items: [T])
    func removeAll()
    func execute(completion: @escaping (Realm) -> Void)
    var all: Results<DModel>? {get}
}

public extension DManager {
    func execute(completion: @escaping (Realm) -> Void) {
        Realm.asyncNew { result in
            switch result {
            case let .success(r):
                r.trySafeWrite {
                    completion(r)
                }
            case .failure:
                Logging.l("Cannot realm execute query")
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

public class ObjectManager {
    public let manager: any DManager
    
    public init(_ manager: any DManager) {
        self.manager = manager
    }
    
    public func add<T: ModelProtocol>(_ items: T...) {
        items.forEach { item in
            manager.add(item)
        }
    }
    
    public func addAll<T: ModelProtocol>(_ items: [T]) {
        manager.addAll(items)
    }
}
