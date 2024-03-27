//
//  DNotification.swift
//  YuzPay
//
//  Created by applebro on 24/02/23.
//

import RealmSwift
import Foundation

public protocol NotificationProtocol: ModelProtocol {
    var logID: Int {get set}
    var logTitle: String? {get set}
    var createdDate: Date? {get set}
    var logStatus: Int? {get set}
    var logDetails: String? {get set}
    var userID: String? {get set}
}

public class DNotification: Object, DObjectProtocol, NotificationProtocol {
    public var id: Int {
        logID
    }
    
    @Persisted(primaryKey: true) public var logID: Int
    
    @Persisted public var logTitle: String?
    
    @Persisted public var createdDate: Date?
    
    @Persisted public var logStatus: Int?
    
    @Persisted public var logDetails: String?
    
    @Persisted public var userID: String?
    
    public init(logID: Int, logTitle: String? = nil, createdDate: Date? = nil, logStatus: Int? = nil, logDetails: String? = nil, userID: String? = nil) {
        self.logTitle = logTitle
        self.createdDate = createdDate
        self.logStatus = logStatus
        self.logDetails = logDetails
        self.userID = userID
        super.init()
        self.logID = logID
    }
    
    public override init() {
        super.init()
    }
    
    public static func build(withModel model: NetResBodyUserLog) -> any DItemProtocol {
        return DNotification(logID: model.logID, logTitle: model.logTitle, createdDate: model.createdDate, logStatus: model.logStatus, logDetails:  model.logDetails, userID: model.userID)
    }
}
