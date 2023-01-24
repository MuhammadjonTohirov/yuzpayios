//
//  ReceiptRowItem.swift
//  YuzPay
//
//  Created by applebro on 23/01/23.
//

import Foundation
import SwiftUI

struct ReceiptRowItem: Identifiable {
    var id: UUID = UUID()
    var name: String
    var value: String
    
    var row: some View {
        VStack {
            HStack {
                Text(name)
                Spacer()
                Text(value)
            }
            .padding(.vertical, Padding.small.sh())
            .padding(.horizontal, Padding.default.sw())
            
            Divider()
        }
        .foregroundColor(.label.opacity(0.85))
        .mont(.regular, size: 14)
    }
}
