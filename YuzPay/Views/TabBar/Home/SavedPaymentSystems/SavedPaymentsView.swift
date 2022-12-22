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
                listItem(icon: "image_mobiuz", title: "Mobi uz")
                listItem(icon: "image_clouds", title: "Cloud")
                listItem(icon: "image_sarkor_telecom", title: "Sarkor telecom")
            }
            .padding(.horizontal, Padding.default)
            .scrollable(axis: .horizontal)
        }
    }
    
    func listItem(icon: String, title: String) -> some View {
        VStack {
            Image(icon)
                .resizable()
                .frame(width: 60.f.sw(), height: 60.f.sw())

            Text(title)
                .padding(.horizontal, Padding.small)
                .padding(.bottom, Padding.medium)
                .font(.mont(.regular, size: 12))
        }
        .frame(width: 100.f.sw(), height: 100.f.sw())
        .background(Color.secondarySystemBackground)
        .cornerRadius(16, style: .circular)
    }
}

struct SavedPaymentsView_Preview: PreviewProvider {
    static var previews: some View {
        SavedPaymentsView()
    }
}
