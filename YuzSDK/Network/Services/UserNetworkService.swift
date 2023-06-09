//
//  AuthService.swift
//  YuzPay
//
//  Created by applebro on 15/02/23.
//

import Foundation

public struct UserNetworkService: NetworkServiceProtocol {
    typealias S = UserNetworkServiceRoute
    
    public static var shared = UserNetworkService()
    
    public func getOTP(forNumber phone: String) async -> NetRes<NetBodyCheckPhone>? {
        return await Network.send(request: S.checkPhone(withNumber: phone))
    }
    
    public func confirm(otp: String) async -> Bool {
        sleep(1)
        return otp == UserSettings.shared.lastOTP
    }
    
    public func refreshToken() async -> Bool {
        guard let token = UserSettings.shared.refreshToken else {
            return false
        }
        
        let result: NetRes<NetResRefreshToken>? = await Network.send(request: S.refreshToken(token: token))
        
        guard let result = result?.data, let accessToken = result.accessToken?.nilIfEmpty else {
            return false
        }
        
        UserSettings.shared.accessToken = accessToken
        UserSettings.shared.refreshToken = result.refreshToken
        UserSettings.shared.accessTokenExpireDate = result.expiresIn
        UserSettings.shared.refresTokenExpireDate = result.refreshExpiresIn
        
        return true
    }

    public func uploadAvatar(url: URL, completion: @escaping (Bool, String?) -> Void) {
        let defaultError = "Unknown failure"
        guard let phone = UserSettings.shared.userPhone,
                let token = UserSettings.shared.checkPhoneToken,
                let otp = UserSettings.shared.lastOTP else {
            completion(false, defaultError)
            return
        }
        
        Network.upload(body: String.self, request: S.phoneRegister(phone: phone, photo: url, token: token, otp: otp)) { res in
            guard let isSuccess = res?.success else {
                completion(false, res?.error ?? defaultError)
                return
            }
            
            isSuccess ? completion(true, nil) : completion(false, res?.error ?? defaultError)
        }
    }
    
    public func deleteAccount() async -> NetResBody? {
        let result: NetRes<NetResDeleteAccount> = await Network.send(request: S.deleteAccount) ?? .init(success: false, data: nil, error: nil, code: -1)
        return result.data
    }
    
    public func confimDeleteAccount(code: String, token: String) async -> Bool {
        let result: NetRes<String> = await Network.send(request: S.confirmDeleteAccount(token: token, code: code)) ?? .init(success: false, data: nil, error: nil, code: -1)
        return result.success
    }
    
    public func logout() async -> Bool {
        let result: NetRes<String> = await Network.send(request: S.logout) ?? .init(success: false, data: nil, error: nil, code: -1)
        return result.success
    }
    
    public func getAccessToken() async -> Bool {
        guard let phone = UserSettings.shared.userPhone,
                let token = UserSettings.shared.checkPhoneToken,
                let otp = UserSettings.shared.lastOTP else {
            return false
        }
        
        guard let result: NetRes<NetResBodyPhoneLogin> = await Network.send(request: S.phoneLogin(number: phone, token: token, code: otp)), let data = result.data else {
            return false
        }
        
        UserSettings.shared.accessToken = data.accessToken
        UserSettings.shared.refreshToken = data.refreshToken
        UserSettings.shared.accessTokenExpireDate = data.expiresIn
        UserSettings.shared.refresTokenExpireDate = data.refreshExpiresIn
        
        return result.success
    }
    
    public func getUserSession() async -> Bool {
        let userSessions: NetRes<[NetResUserSession]>? = await Network.send(request: S.getSessions)
        ObjectManager(UserSessionsManager()).addAll(userSessions?.data ?? [])
        return true
    }
    
    public func getNotifications() async -> NetRes<[NetResBodyUserLog]>? {
        return await Network.send(request: S.getUserLogs)
    }
    
    public func syncNotifications() async {
        let notifications = await getNotifications()
        DataBase.writeNotifications(notifications?.data ?? [])
    }
    
    public func getUserInfo() async -> NetResBodyUserInfo? {
        let res: NetRes<NetResBodyUserInfo>? = await Network.send(request: S.getUserInfo)
        
        return res?.data
    }
    
    public func verifyProfile(photoUrl: URL, completion: @escaping ((Bool, String?) -> Void)) {
        let defaultError = "Unknown failure"
        Logging.l("Verify profile with \(photoUrl.absoluteString)")
        Network.upload(body: String.self, request: S.verifyProfile(photo: photoUrl)) { res in
            guard let isSuccess = res?.success else {
                completion(false, res?.error ?? defaultError)
                return
            }
            
            isSuccess ? completion(true, nil) : completion(false, res?.error ?? defaultError)
        }
    }
}

