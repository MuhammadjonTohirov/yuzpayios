//
//  AboutUsView.swift
//  YuzPay
//
//  Created by applebro on 06/06/23.
//

import Foundation
import SwiftUI

struct AboutUsView: View {
    @State private var appVersion: String = ""
    var body: some View {
        VStack {
            Spacer()
            
            middleLogo
            
            Spacer()
            
            companyInfo(icon: "logo_yuz2", title: "developer".localize, name: "YuzPay Team", iconColor: Color.accentColor)
                .padding(.horizontal, 60)
                .padding(.bottom, 8)
            
            companyInfo(icon: "logo_yuz", title: "with_support".localize, name: "Tadi Industries", iconColor: Color.accentColor)
                .padding(.horizontal, 60)
                .padding(.bottom, 60)
            
            Text("mobile_version".localize(arguments: appVersion))
                .mont(.regular, size: 12)
                .foregroundColor(.secondaryLabel)
        }
        .onAppear {
            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                self.appVersion = version
            }
        }
    }
    
    private func companyInfo(icon: String, title: String, name: String, iconColor: Color = .accentColor) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.opaqueSeparator)
                .foregroundColor(.systemBackground)
                .frame(width: 40, height: 40)
                .overlay {
                    logo(logo: icon, size: 32, bgColor: iconColor)
                        .opacity(0.8)
                        
                }
            
            VStack(alignment: .leading) {
                Text(title)
                    .mont(.regular, size: 13)
                    .foregroundColor(.secondaryLabel)
                Text(name)
                    .mont(.semibold, size: 14)
            }
            
            Spacer()
        }
    }
    
    private var middleLogo: some View {
        VStack {
            logo(size: 72)
            Text("YuzPay")
                .mont(.semibold, size: 32)
        }
        .foregroundColor(.accentColor)
    }
    
    private func logo(logo: String = "logo_yuz2", size: CGFloat = 36, bgColor: Color = .accentColor) -> some View {
        Circle()
            .frame(width: size)
            .foregroundColor(bgColor)
            .overlay {
                Image(logo)
                    .renderingMode(.template)
                    .resizable(true)
                    .frame(width: size * 0.8, height: size * 0.8)
                    .foregroundColor(.white)
            }
    }
}

struct AboutUs_View_Provider: PreviewProvider {
    static var previews: some View {
        AboutUsView()
    }
}
