//
//  InvoicesView.swift
//  YuzPay
//
//  Created by applebro on 03/02/23.
//

import SwiftUI
import Introspect
import RealmSwift
import YuzSDK

extension DInvoiceItem {
    var asModel: InvoiceItemModel {
        .init(invoiceID: invoiceID,
              operatorName: operatorName,
              branchName: branchName,
              organizationName: organizationName,
              clientName: clientName,
              totalAmount: totalAmount,
              invoiceNote: invoiceNote,
              createdDate: createdDate,
              isPaid: isPaid,
              isExpired: isExpired)
    }
}

extension InvoiceItemModel {
    var date: Date {
        return Date.from(string: createdDate ?? "") ?? Date()
    }
    
    var beautifiedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    var priceInfo: String {
        // format the amount as money
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "UZS"
        formatter.currencySymbol = ""
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        formatter.locale = Locale(identifier: "uz_UZ")
        return formatter.string(from: NSNumber(value: totalAmount ?? 0)) ?? ""
    }
    
    var isPayable: Bool {
        return !(isPaid ?? false) && !(isExpired ?? false)
    }
    
    var statusValue: String {
        if isPaid ?? false {
            return "paid".localize
        }
        
        if isExpired ?? false {
            return "expired".localize
        }
        
        return "not_paid".localize
    }
    
    var color: Color {
        if isPaid ?? false {
            return .systemBlue
        }
        
        if isExpired ?? false {
            return .systemRed
        }
        
        return .systemOrange
    }
}

struct InvoicesView: View {
    @State private var searchText: String = ""
    @State private var showPayment = false
    @ObservedResults(DInvoiceItem.self, configuration: Realm.config) var invoices;
    @State private var receiptRowItems: [ReceiptRowItem] = []
    @State private var selectedInvoiceId: Int?
    var body: some View {
        ZStack {
            innerBody
        }
        .onAppear {
            MainNetworkService.shared.syncInvoiceList()
        }
    }
    
    var innerBody: some View {
        List {
            ForEach(invoices) { item in
                NavigationLink {
                    ReceiptAndPayView()
                        .set(rows: receiptRowItems)
                        .set(submitButtonTitle: item.asModel.isPayable ? "pay".localize : "back".localize)
                        .set(showCards: item.asModel.isPayable)
                        .set(onClickSubmit: { cardId in
                            
                        })
                    .onAppear {
                        self.selectedInvoiceId = item.invoiceID
                        self.receiptRowItems = [
                            ReceiptRowItem(name: "organization".localize, value: item.organizationName ?? ""),
                            ReceiptRowItem(name: "date".localize, value: item.asModel.beautifiedDate),
                            ReceiptRowItem(name: "price".localize, value: item.asModel.priceInfo, type: .price),
                        ]
                    }
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
                Text(invoice.organizationName ?? "")
                    .mont(.regular, size: 14)
                Text(invoice.asModel.statusValue)
                    .mont(.semibold, size: 12)
                    .foregroundColor(invoice.asModel.color)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 6) {
                //add formatter to Text with totalAmount
                Text(invoice.asModel.priceInfo)
                    .mont(.semibold, size: 14)
                    
                Text(invoice.asModel.beautifiedDate)
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
