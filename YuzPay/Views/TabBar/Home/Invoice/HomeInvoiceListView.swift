//
//  InvoiceListView.swift
//  YuzPay
//
//  Created by applebro on 22/12/22.
//

import Foundation
import SwiftUI
import RealmSwift
import YuzSDK

struct HomeInvoiceListView: View {
    @ObservedResults(DInvoiceItem.self, configuration: Realm.config) var invoices;

    var body: some View {
        VStack(alignment: .leading) {
            Text("issued_invoices".localize.uppercased())
                .font(.mont(.semibold, size: 16))
                .padding(.bottom, Padding.medium)
            ForEach(invoices[0..<invoices.count.limitTop(3)]) { invoice in
                if let model = invoice.asSafeModel {
                    invoiceItem(model)
                } else {
                    EmptyView()
                }
            }
        }
        .padding(Padding.medium)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(Color.secondarySystemBackground)
        )
    }
    
    private func invoiceItem(_ invoice: InvoiceItemModel) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("\(invoice.organizationName ?? "") \(invoice.branchName ?? "")")
                    .mont(.regular, size: 14)
                    .lineLimit(1)

                Text(invoice.statusValue)
                    .mont(.semibold, size: 12)
                    .foregroundColor(invoice.color)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 6) {
                //add formatter to Text with totalAmount
                Text(invoice.priceInfo)
                    .mont(.semibold, size: 14)
                    
                Text(invoice.beautifiedDate)
                    .mont(.regular, size: 12)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.bottom, Padding.small)
    }
}

struct InvoiceListView_Preview: PreviewProvider {
    static var previews: some View {
        HomeInvoiceListView()
    }
}

