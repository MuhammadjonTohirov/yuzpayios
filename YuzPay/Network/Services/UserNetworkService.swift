//
//  AuthService.swift
//  YuzPay
//
//  Created by applebro on 15/02/23.
//

import Foundation

struct UserNetworkService: NetworkServiceProtocol {
    typealias S = UserNetworkServiceRoute
    
    public static var shared = UserNetworkService()
    
    func getOTP(forNumber phone: String) async -> NetRes<NetBodyCheckPhone>? {
        return await Network.send(request: S.checkPhone(withNumber: phone))
    }
    
    func confirm(otp: String) async -> Bool {
        sleep(1)
        return otp == UserSettings.shared.lastOTP
    }

    func uploadAvatar(url: URL, completion: @escaping (Bool, String?) -> Void) {
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
    
    func deleteAccount() async -> Bool {
        let result: NetRes<String> = await Network.send(request: S.deleteAccount) ?? .init(success: false, data: nil, error: nil, code: -1)
        return result.success
    }
    
    func logout() async -> Bool {
        let result: NetRes<String> = await Network.send(request: S.logout) ?? .init(success: false, data: nil, error: nil, code: -1)
        return result.success
    }
    
    func getAccessToken() async -> Bool {
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
    
    func getUserSession() async -> NetRes<NetResBodySession>? {
        return await Network.send(request: S.getSessions)
    }
    
    func getNotifications() async -> NetRes<NetResBodyUserLog>? {
        return await Network.send(request: S.getSessions)
    }
    
    func getUserInfo() async -> NetResBodyUserInfo? {
        let res: NetRes<NetResBodyUserInfo>? = await Network.send(request: S.getUserInfo)
            
        return res?.data
    }
}
