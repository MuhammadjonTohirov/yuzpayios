//
//  DatabaseConfig.swift
//  YuzPay
//
//  Created by applebro on 20/12/22.
//

import Foundation

struct AppConfig {
    public static let groupId = "group.yuzapp"
}

public struct DatabaseConfig {
    
    public static let version: UInt64 = 4
    
    public static var location: URL {
        FileManager
            .default
            .containerURL(forSecurityApplicationGroupIdentifier: AppConfig.groupId)!
            .appendingPathComponent("v\(version)")
    }
}
