//
//  DUserSession.swift
//  YuzPay
//
//  Created by applebro on 25/02/23.
//

import Foundation
import RealmSwift

protocol DObjectProtocol: DItemProtocol, Identifiable {
    
}

protocol UserSessionProtocol: ModelProtocol {
    var sessionID: Int {get set}
    var userID: String {get set}
    var loginTime: String {get set}
    var clientIP: String {get set}
    var userAgent: String {get set}
}

class DUserSession: Object, DObjectProtocol, UserSessionProtocol {
    var id: Int {
        sessionID
    }
    
    @Persisted(primaryKey: true) var sessionID: Int
    @Persisted var userID: String
    @Persisted var loginTime: String
    @Persisted var clientIP: String
    @Persisted var userAgent: String
    
    init(sessionID: Int, userID: String, loginTime: String, clientIP: String, userAgent: String) {
        self.userID = userID
        self.loginTime = loginTime
        self.clientIP = clientIP
        self.userAgent = userAgent
        super.init()
        self.sessionID = sessionID
    }
    
    override init() {
        super.init()
    }
    
    static func build(withModel model: NetResUserSession) -> any DItemProtocol {
        DUserSession(sessionID: model.sessionID, userID: model.userID, loginTime: model.loginTime, clientIP: model.clientIP, userAgent: model.userAgent)
    }
}
