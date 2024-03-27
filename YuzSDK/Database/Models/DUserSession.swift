//
//  DUserSession.swift
//  YuzPay
//
//  Created by applebro on 25/02/23.
//

import Foundation
import RealmSwift

public protocol DObjectProtocol: DItemProtocol, Identifiable {
    
}

public protocol UserSessionProtocol: ModelProtocol {
    var sessionID: Int {get set}
    var userID: String {get set}
    var loginTime: String {get set}
    var clientIP: String {get set}
    var userAgent: String {get set}
}

public final class DUserSession: Object, DObjectProtocol, UserSessionProtocol {
    public var id: Int {
        sessionID
    }
    
    @Persisted(primaryKey: true) public var sessionID: Int
    @Persisted public var userID: String
    @Persisted public var loginTime: String
    @Persisted public var clientIP: String
    @Persisted public var userAgent: String
    
    public init(sessionID: Int, userID: String, loginTime: String, clientIP: String, userAgent: String) {
        self.userID = userID
        self.loginTime = loginTime
        self.clientIP = clientIP
        self.userAgent = userAgent
        super.init()
        self.sessionID = sessionID
    }
    
    public override init() {
        super.init()
    }
    
    public static func build(withModel model: NetResUserSession) -> any DItemProtocol {
        DUserSession(sessionID: model.sessionID, userID: model.userID, loginTime: model.loginTime, clientIP: model.clientIP, userAgent: model.userAgent)
    }
}
