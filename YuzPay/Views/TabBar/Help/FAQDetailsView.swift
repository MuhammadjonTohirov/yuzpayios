//
//  FAQDetailsView.swift
//  YuzPay
//
//  Created by applebro on 18/01/23.
//

import Foundation
import SwiftUI

struct FAQDetailsView: View {
    let item: HelpItem
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(item.title)
                .mont(.semibold, size: 16)
            Text(item.detail)
                .mont(.regular, size: 14)
                .foregroundColor(.secondaryLabel)
                
            Text(item.date.formatted(date: .numeric, time: .shortened))
                .mont(.regular, size: 12)
                .foregroundColor(.secondaryLabel)
                .padding(.top, Padding.medium)
            
            Spacer()
                .fill(alignment: .leading)
        }
        .navigationTitle("details".localize)
        .scrollable()
        .padding(.horizontal, Padding.default)
    }
}

struct FAQDetails_Preview: PreviewProvider {
    static var previews: some View {
        FAQDetailsView(item: .init(title: "123", detail: "123", date: Date()))
    }
}
