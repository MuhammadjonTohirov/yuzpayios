//
//  SignInTypeView.swift
//  YuzPay
//
//  Created by applebro on 09/12/22.
//

import Foundation
import SwiftUI

enum SelectionRows: Hashable {
    case a
    case b
    case c
}

struct SignInType: View {
    var body: some View {
        VStack(alignment: .center) {
            
            Spacer()
            
            Text("Настройки\nвхода")
                .font(.mont(.extraBold, size: 32))
            
            VStack(spacing: 20) {
                Button {
                    
                } label: {
                    Text("Пунтк списка")
                }
                
                Divider()
                Button {
                    
                } label: {
                    Text("Пунтк списка")
                }
                Divider()
                Button {
                    
                } label: {
                    Text("Пунтк списка")
                }
            }
            .font(.mont(.regular, size: 14))
            .padding(Padding.default)
            .cornerRadius(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(Color("background"))
                    .shadow(color: .black.opacity(0.2), radius: 16, y: 4)
            )
            .padding(Padding.medium)
            
            Spacer()
            
            Button {
                
            } label: {
                Text("Пропустить")
            }
            .padding()
        }
        .multilineTextAlignment(.center)
        
    }
}

struct SignInType_Preview: PreviewProvider {
    static var previews: some View {
        SignInType()
    }
}
