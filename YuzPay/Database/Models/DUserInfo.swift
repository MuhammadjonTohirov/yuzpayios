//
//  DUser.swift
//  YuzPay
//
//  Created by applebro on 21/02/23.
//

import Foundation
import RealmSwift

class DUserInfo: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String
    @Persisted var sub: String
    @Persisted var preferredUsername: String
    @Persisted var familyName: String?
    @Persisted var givenName: String?
    @Persisted var name: String?
    @Persisted var phoneNumber: String?
    @Persisted var isVerified = false
    @Persisted var address: String?
    @Persisted var passportNumber: String?
    
    var verificationStatus: String {
        (isVerified ? "verified" : "not_verified").localize
    }
    init(id: String, sub: String, preferredUsername: String, familyName: String?, givenName: String?, name: String?) {
        self.preferredUsername = preferredUsername
        self.familyName = familyName
        self.givenName = givenName
        self.name = name
        self.sub = sub
        
        super.init()
        
        self.id = id
    }
    
    convenience init(id: String, res: NetResBodyUserInfo) {
        self.init(id: id, sub: res.userID ?? "", preferredUsername: res.userName ?? "", familyName: res.fullName, givenName: "", name: res.userName)
        self.isVerified = res.isVerified ?? false
        self.phoneNumber = res.phoneNumber
        self.address = res.address
        self.passportNumber = res.passportNumber
    }
    
    override init() {
        super.init()
    }
}
