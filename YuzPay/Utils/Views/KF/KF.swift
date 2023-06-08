//
//  KF.swift
//  YuzPay
//
//  Created by applebro on 18/02/23.
//

import SwiftUI
import Kingfisher
import YuzSDK

struct KF: View {
    var imageUrl: URL?
    var cacheKey: String?
    @State private var didAppear = false
    var storageExpiration: StorageExpiration? = nil
    var memoryExpiration: StorageExpiration? = nil
    
    var body: some View {
        if let url = imageUrl {
            KFImage(source: Source.network(ImageResource(downloadURL: url, cacheKey: cacheKey ?? "\(url.absoluteString)_\(UserSettings.shared.userPhone ?? "")")))
                .setHTTPHeader(name: "Authorization", value: "Bearer \(UserSettings.shared.accessToken ?? "")")
                .resizable()
                .placeholder({
                    Image("image_placeholder")
                        .resizable(true)
                        .frame(width: 40, height: 40)
                })
                .aspectRatio(contentMode: .fill)
                .mask({
                    Circle()
                })
                .onAppear {
                    
                }
        } else {
            Image("image_placeholder")
                .resizable(true)
                .frame(width: 40, height: 40)
        }
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
