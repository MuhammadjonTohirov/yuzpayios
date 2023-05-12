//
//  AuthServiceRout.swift
//  YuzPay
//
//  Created by applebro on 16/02/23.
//

import Foundation

enum UserNetworkServiceRoute: URLRequestProtocol {
    
    func request() -> URLRequest {
        var request: URLRequest?

        switch self {
        case let .phoneRegister(_, photoUrl, _, otp):
            request = URLRequest.fromDataRequest(url: url, boundary: "Boundary-\(otp)")
            request?.addValue("\(photoUrl.fileSize)", forHTTPHeaderField: "Content-Length")
        case .checkPhone:
            request = URLRequest.new(url: url)
            request?.allHTTPHeaderFields?["Authorization"] = nil
            request?.httpBody = self.body
        case .getUserInfo:
            request = URLRequest.new(url: url)
            request?.setValue("image/png", forHTTPHeaderField: "accept")
        case .refreshToken:
            request = URLRequest(url: url)
        default:
            request = URLRequest.new(url: url)
            request?.httpBody = self.body
        }

        request?.httpMethod = method.rawValue.uppercased()
        
        return request!
    }

    var url: URL {
        switch self {
        case .checkPhone:
            return URL.base.appendingPath("Account", "CheckPhone")
        case .phoneRegister:
            return URL.base.appendingPath("Account", "PhoneRegister")
        case .deleteAccount:
            return URL.base.appendingPath("api", "Client", "DeleteAccount")
        case .phoneLogin:
            return URL.base.appendingPath("Account", "PhoneLogin")
        case .logout:
            return URL.base.appendingPath("api", "Cabinet", "UserLogout")
        case .getSessions:
            return URL.base.appendingPath("api", "Cabinet", "UserSessions")
        case .getUserLogs:
            return URL.base.appendingPath("api", "Cabinet", "UserLogs")
        case .getUserInfo:
            return URL.base.appendingPath("api", "Cabinet", "UserDetails")
        case .refreshToken(let token):
            return URL.base.appendingPath("Account", "RefreshToken").queries(
                .init(name: "token", value: token)
            )
        }
    }
    
    var body: Data? {
        switch self {
        case let .checkPhone(number):
            return NetReqCheckPhone.init(phone: number).asData
        case let .phoneRegister(phone, photoUrl, token, otp):
            return autoreleasepool {
                guard let data = try? Data.init(contentsOf: photoUrl) else {
                    return nil
                }
                let form = MultipartForm(
                    parts: [
                        .init(name: "Phone", value: phone),
                        .init(name: "Photo", data: data, filename: photoUrl.lastPathComponent, contentType: photoUrl.mimeType),
                        .init(name: "Confirm.Token", value: token),
                        .init(name: "Confirm.Code", value: otp)
                    ],
                    boundary: "Boundary-\(otp)")
                return form.bodyData
            }
        case let .phoneLogin(number, token, code):
            return NetReqPhoneLogin(phone: number, confirm: .init(token: token, code: code)).asData
        default:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .checkPhone, .phoneRegister, .phoneLogin, .logout, .refreshToken:
            return .post
        case .deleteAccount:
            return .delete
        case .getUserLogs, .getSessions, .getUserInfo:
            return .get
        }
    }

    case checkPhone(withNumber: String)
    case phoneLogin(number: String, token: String, code: String)
    case phoneRegister(phone: String, photo: URL, token: String, otp: String)
    case refreshToken(token: String)
    case deleteAccount
    case logout
    case getSessions
    case getUserLogs
    case getUserInfo
}
