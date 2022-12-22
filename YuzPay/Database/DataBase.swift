//
//  DataBase.swift
//  YuzPay
//
//  Created by applebro on 21/12/22.
//

import Foundation

class DataBase {
    static let writeThread = DispatchQueue(label: "databaseWrite", qos: .background)
}
