//
//  SimpleRowButton.swift
//  YuzPay
//
//  Created by applebro on 11/05/23.
//

import SwiftUI

struct SimpleRowButton: View {
    var title: String
    var subtitle: String
    var isPlaceholder: Bool = true
    
    var body: some View {
        row(title: title, subtitle: subtitle, isPlaceholder)
    }
    
    private func row(title: String, subtitle: String, _ isPlaceholder: Bool = true) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .mont(.regular, size: 16)
                .padding(.leading, Padding.medium)
            HStack {
                Text(subtitle)
                    .mont(isPlaceholder ? .light : .semibold, size: isPlaceholder ? 14 : 16)
                    .foregroundColor(isPlaceholder ? .secondaryLabel : .label)

                Spacer()

                Image(systemName: "chevron.right")
            }
            .padding()
            .modifier(YTextFieldBackgroundGrayStyle())
            .frame(height: 50)
        }
        
    }
}
