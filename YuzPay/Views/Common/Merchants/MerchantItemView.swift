//
//  MerchantItemView.swift
//  YuzPay
//
//  Created by applebro on 24/01/23.
//

import SwiftUI

struct MerchantItemView: View {
    var icon: String
    var title: String
    
    var width: CGFloat = 100.f.sw()
    var height: CGFloat = 100.f.sw()
    
    var body: some View {
        VStack {
            Image(icon)
                .resizable()
                .frame(width: 60.f.sw(), height: 60.f.sw())

            Text(title)
                .padding(.horizontal, Padding.small)
                .padding(.bottom, Padding.medium)
                .font(.mont(.regular, size: 12))
        }
        .frame(width: width, height: height)
        .background(Color.secondarySystemBackground)
        .cornerRadius(16, style: .circular)
    }
}
