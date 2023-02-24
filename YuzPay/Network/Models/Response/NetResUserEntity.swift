//
//  NetResUserEntity.swift
//  YuzPay
//
//  Created by applebro on 24/02/23.
//

import SwiftUI

struct NetResUserEntity: NetResBody {
    let id: String
    let createdTimestamp: Int?
    let username: String?
    let enabled, totp, emailVerified: Bool?
    let firstName, lastName, email: String?
    let disableableCredentialTypes, requiredActions: [String]?
    let notBefore: Int?
    let access: UserAccess?
    let attributes: UserAttributes?
    let clientConsents: [String]?
    let clientRoles: UserClientRoles?
    let credentials, federatedIdentities: [String]?
    let federationLink: String?
    let groups: [String]?
    let origin: String?
    let realmRoles: [String]?
    let netResUserEntitySelf, serviceAccountClientID: String?

    enum CodingKeys: String, CodingKey {
        case id, createdTimestamp, username, enabled, totp, emailVerified, firstName, lastName, email, disableableCredentialTypes, requiredActions, notBefore, access, attributes, clientConsents, clientRoles, credentials, federatedIdentities, federationLink, groups, origin, realmRoles
        case netResUserEntitySelf = "self"
        case serviceAccountClientID = "serviceAccountClientId"
    }
}

// MARK: - Attributes
struct UserAttributes: Codable {
    let additionalProp1, additionalProp2, additionalProp3: [String]?
}

// MARK: - ClientRoles
struct UserClientRoles: Codable {
    let additionalProp1, additionalProp2, additionalProp3: String?
}

struct UserAccess: Codable {
    let manageGroupMembership, view, mapRoles, impersonate: Bool
    let manage: Bool
}
