//
//  ReceiptRowItem.swift
//  YuzPay
//
//  Created by applebro on 23/01/23.
//

import Foundation
import SwiftUI

enum ReceiptRowType {
    case price
    case regular
}

struct ReceiptRowItem: Identifiable {
    var id: UUID = UUID()
    var name: String
    var value: String
    var type: ReceiptRowType = .regular
    
    var row: some View {
        VStack {
            HStack {
                Text(name)
                    .fontWeight(.medium)
                Spacer()
                Text(value)
                    .mont(.regular, size: 14)
                    .fontWeight(type == .price ? .semibold : .regular)
            }
            .padding(.vertical, Padding.small.sh())
            .padding(.horizontal, Padding.default.sw())
            
            Divider()
        }
        .foregroundColor(.label.opacity(0.85))
        .mont(.regular, size: 14)
    }
}
