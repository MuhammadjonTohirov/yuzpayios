//
//  DNotification.swift
//  YuzPay
//
//  Created by applebro on 24/02/23.
//

import RealmSwift

protocol NotificationProtocol: ModelProtocol {
    var logID: Int {get set}
    var logTitle: String? {get set}
    var createdDate: String? {get set}
    var logStatus: Int? {get set}
    var logDetails: String? {get set}
    var userID: String? {get set}
}

class DNotification: Object, DObjectProtocol, NotificationProtocol {
    var id: Int {
        logID
    }
    
    @Persisted(primaryKey: true) var logID: Int
    
    @Persisted var logTitle: String?
    
    @Persisted var createdDate: String?
    
    @Persisted var logStatus: Int?
    
    @Persisted var logDetails: String?
    
    @Persisted var userID: String?
    
    init(logID: Int, logTitle: String? = nil, createdDate: String? = nil, logStatus: Int? = nil, logDetails: String? = nil, userID: String? = nil) {
        self.logTitle = logTitle
        self.createdDate = createdDate
        self.logStatus = logStatus
        self.logDetails = logDetails
        self.userID = userID
        super.init()
        self.logID = logID
    }
    
    override init() {
        super.init()
    }
    
    static func build(withModel model: NetResBodyUserLog) -> any DItemProtocol {
        return DNotification(logID: model.logID, logTitle: model.logTitle, createdDate: model.createdDate, logStatus: model.logStatus, logDetails:  model.logDetails, userID: model.userID)
    }
}
