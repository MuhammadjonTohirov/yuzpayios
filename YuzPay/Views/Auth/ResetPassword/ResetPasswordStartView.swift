//
//  ResetPasswordStartView.swift
//  YuzPay
//
//  Created by applebro on 12/12/22.
//

import Foundation
import SwiftUI

struct ResetPasswordStartView: View {
    var body: some View {
        VStack(spacing: 40.f.sh(limit: 0.8)) {
            Text("reset_password".localize)
                .font(.mont(.extraBold, size: 32))
            
            HStack(spacing: 16) {
                button(title:"telephone".localize, iconName:  "icon_phone")
                button(title: "face".localize, iconName: "icon_user")
            }
        }
        .multilineTextAlignment(.center)
        .foregroundColor(Color("accent_light"))
    }
    
    func button(title: String, iconName: String) -> some View {
        Button(action: {
            
        }, label: {
            VStack(spacing: 8) {
                Image(iconName)
                    .renderingMode(.template)
                    .padding(.horizontal, 84.f.sw(limit: 0.8))
                Text(title)
                    .font(.mont(.regular, size: 14))
            }
        })
        .padding(.vertical, 22.f.sh())
        .background(
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(Color("background"))
                .shadow(color: .black.opacity(0.12), radius: 8, y: 4)
        )
    }
}

struct ResetPasswordStart_Previewer: PreviewProvider {
    static var previews: some View {
        ResetPasswordStartView()
    }
}
