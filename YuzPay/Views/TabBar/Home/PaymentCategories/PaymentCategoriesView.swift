//
//  PaymentCategoriesView.swift
//  YuzPay
//
//  Created by applebro on 22/12/22.
//

import Foundation
import SwiftUI

struct PaymentCategoriesView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 8) {
                Image("icon_cart")
                    .resizable()
                    .frame(width: 20, height: 20)
                    
                Text("payment".localize)
                    .font(.mont(.semibold, size: 16))
            }
            .padding(.leading, Padding.medium)
            .padding(.horizontal, Padding.default)

            HStack(spacing: 10) {
                listItem(icon: "icon_star", title: "popular".localize)
                listItem(icon: "icon_smartphone", title: "mobile".localize)
                listItem(icon: "icon_wifi", title: "internet".localize)
                listItem(icon: "icon_tv", title: "television".localize)
                listItem(icon: "icon_phone_2", title: "telephone".localize)
                listItem(icon: "icon_server", title: "hosting".localize)
            }
            .padding(.horizontal, Padding.default)
            .scrollable(axis: .horizontal)
        }
    }
    
    func listItem(icon: String, title: String) -> some View {
        VStack {
            Image(icon)
            Text(title)
                .font(.mont(.regular, size: 12))
        }
        .frame(width: 100.f.sw(), height: 100.f.sw())
        .background(Color.secondarySystemBackground)
        .cornerRadius(16, style: .circular)
    }
}

struct PaymentCategoriesView_Preview: PreviewProvider {
    static var previews: some View {
        PaymentCategoriesView()
    }
}
