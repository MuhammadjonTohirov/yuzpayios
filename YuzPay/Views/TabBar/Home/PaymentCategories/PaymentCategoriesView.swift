//
//  PaymentCategoriesView.swift
//  YuzPay
//
//  Created by applebro on 22/12/22.
//

import Foundation
import SwiftUI
import RealmSwift
import YuzSDK

struct PaymentCategoriesView: View {
    @ObservedResults(DMerchantCategory.self, configuration: Realm.config) var categories;
    var onSelectCategory: ((DMerchantCategory) -> Void)
    var body: some View {
        VStack(alignment: .leading, spacing: Padding.medium) {
            HStack(spacing: 8) {
                Image("icon_cart")
                    .resizable()
                    .frame(width: 20, height: 20)
                    
                Text("payment".localize)
                    .font(.mont(.semibold, size: 16))
            }
            .padding(.horizontal, Padding.default)

            HStack(alignment: .center, spacing: 10) {
                ForEach(categories[0..<categories.count.limitTop(5)]) { cat in
                    Button {
                        onSelectCategory(cat)
                    } label: {
                        listItem(icon: "cat\(cat.id)", title: cat.title)
                    }

                }
            }
            .padding(.horizontal, Padding.default)
            .scrollable(axis: .horizontal)
        }
    }
    
    func listItem(icon: String, title: String) -> some View {
        VStack(alignment: .center, spacing: 8) {
            Image(icon)
                .renderingMode(.template)
                .resizable(true)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.black.opacity(0.8))
                .frame(.init(w: 28, h: 28))
                .padding(.top, 18)
            
            Text(title)
                .font(.mont(.medium, size: 12))
                .padding(.horizontal, Padding.small)
            Spacer()
        }
        .frame(width: 100.f.sw(), height: 100.f.sw())
        .background(Color.secondarySystemBackground)
        .cornerRadius(16, style: .circular)
    }
}

struct PaymentCategoriesView_Preview: PreviewProvider {
    static var previews: some View {
        PaymentCategoriesView { _ in
            
        }
    }
}
