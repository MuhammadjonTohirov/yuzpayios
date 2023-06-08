//
//  DItemProtocol.swift
//  YuzPay
//
//  Created by applebro on 21/12/22.
//

import Foundation
import RealmSwift

public protocol DItemProtocol: Object {
    associatedtype Item = ModelProtocol
    static func build(withModel model: Item) -> any DItemProtocol
}
