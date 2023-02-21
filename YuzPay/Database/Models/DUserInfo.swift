//
//  DUser.swift
//  YuzPay
//
//  Created by applebro on 21/02/23.
//

import Foundation
import RealmSwift

class DUserInfo: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var sub: String
    @Persisted var preferredUsername: String
    @Persisted var familyName: String?
    @Persisted var givenName: String?
    @Persisted var name: String?
    @Persisted var email: String?
    @Persisted var emailVerified: Bool
    @Persisted var locale: String
    
    init(id: String, sub: String, preferredUsername: String, familyName: String?, givenName: String?, name: String?, email: String?, emailVerified: Bool, locale: String?) {
        self.preferredUsername = preferredUsername
        self.familyName = familyName
        self.givenName = givenName
        self.name = name
        self.email = email
        self.emailVerified = emailVerified
        self.locale = locale ?? "uz"
        self.sub = sub
        
        super.init()
        
        self.id = id
    }
    
    convenience init(id: String, res: NetResBodyUserInfo) {
        self.init(id: id, sub: res.sub ?? "", preferredUsername: res.preferredUsername ?? "", familyName: res.familyName, givenName: res.givenName, name: res.name, email: res.email, emailVerified: res.emailVerified ?? false, locale: res.locale ?? UserSettings.shared.language?.code)
    }
    
    override init() {
        super.init()
    }
}
