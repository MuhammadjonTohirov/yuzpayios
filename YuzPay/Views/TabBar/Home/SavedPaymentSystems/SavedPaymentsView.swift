//
//  SavedPaymentsView.swift
//  YuzPay
//
//  Created by applebro on 22/12/22.
//

import Foundation
import SwiftUI

struct SavedPaymentsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image("icon_save")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("saved_payment".localize)
                    .font(.mont(.semibold, size: 16))
            }
            .padding(.leading, Padding.medium)
            .padding(.horizontal, Padding.default)
            
            HStack(spacing: 10) {
                MerchantItemView(icon: "image_mobiuz", title: "Mobi uz")
                MerchantItemView(icon: "image_clouds", title: "Cloud")
                MerchantItemView(icon: "image_sarkor_telecom", title: "Sarkor telecom")
            }
            .padding(.horizontal, Padding.default)
            .scrollable(axis: .horizontal)
        }
    }
}

struct SavedPaymentsView_Preview: PreviewProvider {
    static var previews: some View {
        SavedPaymentsView()
    }
}
