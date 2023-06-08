//
//  RightChevron.swift
//  YuzPay
//
//  Created by applebro on 17/01/23.
//

import Foundation
import SwiftUI

struct RightChevron: View {
    var body: some View {
        Image(systemName: "chevron.right")
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 12)
            .foregroundColor(.tertiaryLabel)
    }
}
