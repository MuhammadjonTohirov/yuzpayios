//
//  PassportRegister.swift
//  YuzPay
//
//  Created by applebro on 12/12/22.
//

import Foundation
import SwiftUI

struct PassportRegisterView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Шаг 1 / 3:")
                .font(.mont(.regular, size: 14))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .stroke(style: .init(dashPhase: 1))
                )
                .padding(.bottom, Padding.default)
                .padding(.top, Padding.default)
                .foregroundColor(Color("accent_light"))

            Text("паспортные данные")
                .font(.mont(.extraBold, size: 32))
                .foregroundColor(Color("accent_light"))
                .padding(.bottom, Padding.medium)
            
            Text("Паспортные данные необходимы, чтобы подтвердить Вашу личность и открыть полный доступ ко всем услугам.")
                .font(.mont(.regular, size: 15))
                .padding(.bottom, Padding.default)
            
            HStack(spacing: 16) {
                Image("icon_checkbox_on")
                    .resizable()
                    .frame(width: 20.f.sw(limit: 1.6), height: 20.f.sw(limit: 1.6))
                    .onTapGesture {
                        
                    }
                
                Text(
                    "public_offer".localize, configure: { attr in
                        if let range = attr.range(of: "the_offer".localize) {
                            attr[range].foregroundColor = Color("accent_light")
                            attr[range].link = URL(string: "https://google.com")
                            attr[range].underlineStyle = NSUnderlineStyle.single
                        }
                    }
                )
                .font(.mont(.regular, size: 16))
                
            }
            .padding(.top, Padding.default)
            
            Spacer()
        }
        .padding(.horizontal, Padding.medium)
    }
}
    
struct PassportRegisterView_Preview: PreviewProvider {
    static var previews: some View {
        PassportRegisterView()
    }
}

