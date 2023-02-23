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
            KF(imageUrl: URL(string: icon))
                .frame(width: 40.f.sw(), height: 40.f.sw())
                .background(Circle().foregroundColor(.systemBackground))
                .padding(.top, 4)

            Text(title)
                .lineLimit(2)
                .padding(.horizontal, Padding.small)
                .padding(.bottom, Padding.medium)
                .font(.mont(.regular, size: 12))
        }
        .frame(width: width, height: height)
        .background(Color.secondarySystemBackground)
        .cornerRadius(16, style: .circular)
    }
}
