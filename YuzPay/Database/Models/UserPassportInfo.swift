//
//  File.swift
//  YuzPay
//
//  Created by applebro on 13/12/22.
//

import Foundation
import RealmSwift

public struct UserInfoDetails: Codable {
    public let firstName: String
    public let lastName: String
    public let middleName: String
    public let birthDate: String
}
