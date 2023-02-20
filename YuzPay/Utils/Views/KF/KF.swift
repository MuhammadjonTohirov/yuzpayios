//
//  KF.swift
//  YuzPay
//
//  Created by applebro on 18/02/23.
//

import SwiftUI
import Kingfisher

struct KF: View {
    var imageUrl: URL?
    @State private var didAppear = false
    
    var body: some View {
        KFImage(imageUrl)
            .setHTTPHeader(name: "Authorization", value: "Bearer \(UserSettings.shared.accessToken ?? "")")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .mask({
                Circle()
            })
    }
    
}

extension KFImage {
    func setHTTPHeader(name: String, value: String) -> KFImage {
        let modifier = AnyModifier { request in
            var newRequest = request
            newRequest.httpMethod = "GET"
            newRequest.setValue(value, forHTTPHeaderField: name)
            return newRequest
        }
        
        return self.requestModifier(modifier)
    }
}
