//
//  BorderedCardIcon.swift
//  YuzPay
//
//  Created by applebro on 19/01/23.
//

import SwiftUI

struct BorderedCardIcon: View {
    var name: String
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(Color.opaqueSeparator)
            .foregroundColor(.systemBackground)
            .frame(width: 40, height: 40)
            .overlay {
                Image(name)
                    .resizable(true)
                    .padding(4)
                    .frame(width: 32, height: 32)
            }
    }
}

struct BorderedCardIcon_Previews: PreviewProvider {
    static var previews: some View {
        BorderedCardIcon(name: "icon_card")
            

    }
}
