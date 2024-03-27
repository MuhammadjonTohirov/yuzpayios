//
//  MerchantItemView.swift
//  YuzPay
//
//  Created by applebro on 24/01/23.
//

import SwiftUI
import Kingfisher

struct MerchantItemView: View {
    var icon: String
    var title: String
    
    var width: CGFloat = 100.f.sw()
    var height: CGFloat = 100.f.sw()
    
    var body: some View {
        autoreleasepool {
            ZStack {

                VStack {
                    KFImage(URL(string: icon))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40.f.sw(), height: 40.f.sw())
                        .background(Circle().foregroundColor(.systemBackground))
                    Spacer()
                }
                .padding(.top, 14)

                VStack {
                    Text(title)
                        .lineLimit(2)
                        .font(.mont(.medium, size: 12))
                    
                    Spacer()

                }
                .padding(.horizontal, Padding.small)
                .padding(.top, 40.f.sw() + 18)
            }
            .frame(width: width, height: height)
            .background(Color.secondarySystemBackground.opacity(0.3))
            .cornerRadius(16, style: .circular)
        }
    }
}
