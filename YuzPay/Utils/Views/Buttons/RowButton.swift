//
//  RowButton.swift
//  YuzPay
//
//  Created by applebro on 17/01/23.
//

import SwiftUI

struct RowButton: View {
    var icon: Image
    var text: String
    var details: String? = nil
    var onClick: () -> Void
    var accessoryIcon: (() -> AnyView)? = nil
    var body: some View {
        Button {
            onClick()
        } label: {
            innerBody
        }
    }
    var innerBody: some View {
        HStack(spacing: Padding.small.sw()) {
            Rectangle()
                .foregroundColor(.clear)
                .overlay {
                    icon
                        .renderingMode(.template)
                        .resizable(true)
                        .foregroundColor(Color.tertiaryLabel)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, alignment: .center)
                }
                .frame(width: 40.f.sw(), height: 40.f.sw())

            
            Text(text)
                .mont(.regular, size: 14)
            
            Spacer()
            
            if let d = details {
                Text(d)
                    .mont(.regular, size: 14)
                    .foregroundColor(.secondaryLabel)
            }
            
            if let ic = accessoryIcon?() {
                Rectangle()
                    .frame(width: 40.f.sw(), height: 40.f.sw())
                    .foregroundColor(.clear)
                    .overlay {
                        ic
                    }
            }
        }
    }
}

struct RowButton_Previews: PreviewProvider {
    static var previews: some View {
        RowButton(
            icon: Image("icon_trash"),
            text: "Language",
            details: "English", onClick: {
                
            }) {
                AnyView(
                    Image(systemName: "chevron.right")
                        .renderingMode(.template)
                        .foregroundColor(.secondaryLabel)
                )
            }
    }
}
