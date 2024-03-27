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

struct InvoicesView: View {
    @ObservedResults(DInvoiceItem.self, configuration: Realm.config) var invoices;

    @State private var searchText: String = ""
    @State private var receiptRowItems: [ReceiptRowItem] = []
    @State private var selectedInvoiceId: Int?
    @State private var showAlert: Bool = false
    @State private var alert: AlertToast = .init(displayMode: .alert, type: .regular)
    @State private var showReceipt = false
    @State private var selectedItem: InvoiceItemModel?

    var body: some View {
        ZStack {
            innerBody
                .toast($showAlert, alert, duration: 2.5)
                .sheet(isPresented: $showReceipt, onDismiss: {
                    Logging.l("Dismiss receipt view")
                }) {
                    NavigationView {
                        ReceiptAndPayView(rows: $receiptRowItems)
                            .set(submitButtonTitle: (selectedItem?.isPayable ?? false) ? "pay".localize : "back".localize)
                            .set(showCards: selectedItem?.isPayable ?? false)
                            .set(onClickSubmit: { cardId in
                                if let id = selectedItem?.invoiceID,
                                    selectedItem?.isPayable ?? false {
                                    self.doPayment(id, cardId)
                                }
                            })
                            .set(filter: { card in
                                card.isLocalCard
                            })
                            .navigationTitle(selectedItem?.branchName ?? "")
                    }
                    .presentationDetents([.fraction(0.99)])
                }
        }
        .onAppear {
            MainNetworkService.shared.syncInvoiceList()
            selectedItem = invoices.first?.asModel
        }
    }
    
    var innerBody: some View {
        List {
            ForEach(invoices.sorted(byKeyPath: "createdDate", ascending: false)) { item in
                Button {
                    self.selectedItem = item.asModel
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.receiptRowItems = [
                            .init(name: "organization".localize, value: item.organizationName ?? ""),
                            .init(name: "branch".localize, value: item.branchName ?? ""),
                            .init(name: "date".localize, value: item.asModel.beautifiedDate),
                            .init(name: "price".localize, value: item.asModel.priceInfo, type: .price),
                            .init(name: "status".localize, value: item.asModel.statusValue)
                        ]
                        self.showReceipt = true
                    }
                } label: {
                    invoiceItem(item)
                        .padding(.vertical, Padding.small)
                }
                    
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("invoices".localize)
    }
    
    private func invoiceItem(_ invoice: DInvoiceItem) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("\(invoice.organizationName ?? "") \(invoice.branchName ?? "")")
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
    
    private func doPayment(_ invoiceId: Int, _ cardId: String) {
        Task {
            let result = await MainNetworkService.shared.doInvoicePayment(invoiceId: invoiceId, cardId: Int(cardId)!)
            
            showAlert(.init(
                displayMode: .alert,
                type: result.success ? .regular : .error(.systemOrange),
                title: result.success ? "successfully_paid".localize : (result.error ?? "error_in_payment".localize)))
        }
    }
    
    private func showAlert(_ alert: AlertToast) {
        self.alert = alert
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showAlert = true
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
    
    var asSafeModel: InvoiceItemModel? {
        if self.isInvalidated {
            return nil
        }
        
        return asModel
    }
}

extension InvoiceItemModel {
    var date: Date {
        return createdDate ?? Date()
    }
    
    var beautifiedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd.MM.yyyy"
        formatter.timeZone = .init(abbreviation: "GMT+5")
        formatter.calendar = .current
        return formatter.string(from: date)
    }
    
    var priceInfo: String {
        // format the amount as money
        totalAmount?.asCurrency() ?? ""
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

