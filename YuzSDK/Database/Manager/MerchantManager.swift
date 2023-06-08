//
//  PaymentItemManager.swift
//  YuzPay
//
//  Created by applebro on 21/12/22.
//

import Foundation
import RealmSwift

public enum MobileOperator {
    case ucell
    case beeline
    case perfectum
    case uzmobile
    case ums
    
    public var codes: [String] {
        switch self {
        case .ucell:
            return ["93", "94", "50"]
        case .beeline:
            return ["90", "91"]
        case .perfectum:
            return ["98"]
        case .uzmobile:
            return ["77", "95", "99"]
        case .ums:
            return ["88", "97"]
        }
    }
}

public struct MerchantManager: DManager {
    typealias Obj = MerchantItemModel
    
    public init() {
        
    }
        
    public func add<T>(_ items: T...) where T : ModelProtocol {
        execute { realm in
            items.forEach { _merchant in
                if let merchant = _merchant as? MerchantItemModel {
                    realm.add(DMerchant.build(withModel: merchant), update: .modified)
                }
            }
        }
    }
    
    public func addAll<T>(_ items: [T]) where T : ModelProtocol {
        execute { realm in
            let objs = items.compactMap({DMerchant.build(withModel: $0 as!MerchantItemModel)})
            realm.add(objs, update: .modified)
        }
    }
    
    public var all: Results<DMerchant>? {
        Realm.new?.objects(DMerchant.self)
    }
    
    public var mobileOperators: Results<DMerchant>? {
        Realm.new?.objects(DMerchant.self).filter("id IN %@", ["44", "45", "21", "2", "2915"])
    }
    
    public func operatorWith(code: String) -> DMerchant? {
        let operators: [MobileOperator] = [.beeline, .perfectum, .ucell, .ums, .uzmobile]
        guard let `operator` = operators.first(where: {$0.codes.contains(code)}) else {
            return nil
        }
        
        switch `operator` {
        case .beeline:
            return all?.filter("id == %@", "2").first
        case .uzmobile:
            return all?.filter("id == %@", "45").first
        case .ucell:
            return all?.filter("id == %@", "44").first
        case .perfectum:
            return all?.filter("id == %@", "21").first
        case .ums:
            return all?.filter("id == %@", "2915").first
        }
    }
}


