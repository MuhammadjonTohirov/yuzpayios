//
//  InvoicesView.swift
//  YuzPay
//
//  Created by applebro on 03/02/23.
//

import SwiftUI
import Introspect
import RealmSwift

struct InvoicesView: View {
    @State private var searchText: String = ""
    @State private var showPayment = false
    @ObservedResults(DInvoiceItem.self, configuration: Realm.config) var invoices;
    
    var body: some View {
        ZStack {
            NavigationLink("", isActive: $showPayment) {
                MerchantPaymentView(merchantId: "0")
            }
            innerBody
        }
        .onAppear {
            MainNetworkService.shared.syncInvoiceList()
        }
    }
    
    var innerBody: some View {
        List {
            ForEach(invoices) { item in
                Button {
                    showPayment = true
                } label: {
                    invoiceItem(item)
                        .padding(.vertical, Padding.small)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText)
        .navigationTitle("invoices".localize)
    }
    
    func invoiceItem(_ invoice: DInvoiceItem) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("Korzinka #12093239")
                    .mont(.regular, size: 14)
                Text("К оплате")
                    .mont(.semibold, size: 12)
                    .foregroundColor(.systemBlue)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 6) {
                Text("100 000 usd")
                    .mont(.semibold, size: 14)
                    
                Text("15:32 12.12.2022")
                    .mont(.regular, size: 12)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct InvoicesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            InvoicesView()
        }
    }
}
