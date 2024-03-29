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
            
            Text("login_settings".localize)
                .font(.mont(.extraBold, size: 32))
            
            VStack(spacing: 20) {
                Button {
                    
                } label: {
                    Text("list_item".localize) // Пункт списка
                }
                
                Divider()
                Button {
                    
                } label: {
                    Text("list_item".localize) // Пункт списка
                }
                Divider()
                Button {
                    
                } label: {
                    Text("list_item".localize) // Пункт списка
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
                Text("skip".localize)
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
