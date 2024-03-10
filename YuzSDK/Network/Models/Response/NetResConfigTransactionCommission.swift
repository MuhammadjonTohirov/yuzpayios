//
//  NetResConfigTransactionCommission.swift
//  YuzSDK
//
//  Created by applebro on 10/03/24.
//

import Foundation

public struct NetResConfigTransactionCommission: NetResBody {
    public let p2p: NetResConfigP2P // p2P
    public let store, exchange, paynet: Float?
    
    // coding keys
    enum CodingKeys: String, CodingKey {
        case p2p = "p2P"
        case store, exchange, paynet
    }
}

public struct NetResConfigP2P: NetResBody {
    public let visa, humo, uzCard: Float?
}
