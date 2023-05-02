//
//  DUser.swift
//  YuzPay
//
//  Created by applebro on 21/02/23.
//

import Foundation
import RealmSwift

public final class DUserInfo: Object, Identifiable {
    @Persisted(primaryKey: true) public var id: String
    @Persisted public var sub: String
    @Persisted public var preferredUsername: String
    @Persisted public var familyName: String?
    @Persisted public var givenName: String?
    @Persisted public var name: String?
    @Persisted public var phoneNumber: String?
    @Persisted public var isVerified = false
    @Persisted public var address: String?
    @Persisted public var passportNumber: String?
    
    public var verificationStatus: String {
        (isVerified ? "verified" : "not_verified").localize
    }
    
    public init(id: String, sub: String, preferredUsername: String, familyName: String?, givenName: String?, name: String?) {
        self.preferredUsername = preferredUsername
        self.familyName = familyName
        self.givenName = givenName
        self.name = name
        self.sub = sub
        
        super.init()
        
        self.id = id
    }
    
    public convenience init(id: String, res: NetResBodyUserInfo) {
        self.init(id: id, sub: res.userID ?? "", preferredUsername: res.userName ?? "", familyName: res.fullName, givenName: "", name: res.userName)
        self.isVerified = res.isVerified ?? false
        self.phoneNumber = res.phoneNumber
        self.address = res.address
        self.passportNumber = res.passportNumber
    }
    
    public override init() {
        super.init()
    }
}
