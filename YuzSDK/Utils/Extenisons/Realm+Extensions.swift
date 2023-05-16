//
//  Realm+Extensions.swift
//  YuzPay
//
//  Created by applebro on 20/12/22.
//

import Foundation
import RealmSwift

extension Realm {
    public static var config: Realm.Configuration {
        Realm.Configuration.init(schemaVersion: DatabaseConfig.version, deleteRealmIfMigrationNeeded: true, shouldCompactOnLaunch: nil)
    }
    
    public static var new: Realm? {
        return try? Realm.init(configuration: config)
    }

    public static func asyncNew(_ completion: @escaping (Result<Realm, NSError>) -> Void) {
        Realm.asyncOpen(configuration: config, callbackQueue: DataBase.writeThread) { result in
            switch result {
            case .success(let realm):
                completion(.success(realm))
            case .failure(let error):
                completion(.failure(error as NSError))
            }
        }
    }
    
    public static func asyncNewSafe(_ block: @escaping (Realm) -> Void) {
        DataBase.writeThread.async {
            Realm.asyncNew { realmObject in
                switch realmObject {
                case .success(let realm):
                    block(realm)
                case .failure:
                    break
                }
            }
        }
    }
}

extension Realm {
    public func trySafeWrite(_ block: () throws -> Void, completionHandler: ((NSError?) -> Void)? = nil) {
        do {
            
            func write() throws {
                beginWrite()
                try block()
                try commitWrite()
                
                completionHandler?(nil)
            }
            
            if isInWriteTransaction {
                try block()
                completionHandler?(nil)
            } else {
                try write()
                
            }
        } catch {
            completionHandler?(error as NSError)
            debugPrint("Cannot try safe write")
        }
    }
    
    public func reCreate<E: Object>(object: E, with id: String) -> E {
        self.trySafeWrite {
            if let obj = self.object(ofType: E.self, forPrimaryKey: id) {
                self.delete(obj)
            }
        }
        
        return object
    }
    
    public func asyncSafeWrite(_ block: @escaping () -> Void, onComplete: @escaping () -> Void) {
        Realm.asyncNew { realmObject in
            switch realmObject {
            case .success(let realm):
                realm.trySafeWrite(block)
            case .failure:
                break
            }
        }
    }
    
    public func object<T: Object>(ofType: T.Type, byKey: String, value: String) -> T? {
        self.objects(ofType).filter(NSPredicate(format: "\(byKey) = %@", value)).first
    }
    
    public func object<T: Object>(ofType: T.Type, byKey: String, value: Int) -> T? {
        self.objects(ofType).filter(NSPredicate(format: "\(byKey) = %d", value)).first
    }

    public func object<T: Object>(ofType: T.Type, byKey: String, value: Int64) -> T? {
        self.objects(ofType).filter(NSPredicate(format: "\(byKey) = %d", value)).first
    }

    public func object<T: Object>(ofType: T.Type, byKey: String, value: Double) -> T? {
        self.objects(ofType).filter(NSPredicate(format: "\(byKey) = %d", value)).first
    }

    public func object<T: Object>(ofType: T.Type, byKeys keys: String..., value: String) -> T? {
        if keys.isEmpty {
            return nil
        }
        
        var pred = keys.reduce("", {"\($0) \($1) = %@ OR"})
        pred.removeLast()
        pred.removeLast()
        pred.removeLast()
        
        return self.objects(ofType).filter(NSPredicate(format: pred, argumentArray: keys.map({_ in value}))).first
    }
    
    static public func useAsync<T: Object>(object: T, in thread: DispatchQueue, completion: @escaping (T) -> Void) {
        let ref = ThreadSafeReference(to: object)
        
        thread.async {
            if let rlm = Realm.new, let tp = rlm.resolve(ref) {
                completion(tp)
            }
        }
    }
}

public extension Results {
    func item(at: Int) -> Element? {
        if at < 0 {
            return nil
        }
        
        if at >= self.count {
            return nil
        }
        
        return self[at]
    }
}
