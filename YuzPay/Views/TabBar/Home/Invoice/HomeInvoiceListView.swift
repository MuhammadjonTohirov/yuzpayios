//
//  InvoiceListView.swift
//  YuzPay
//
//  Created by applebro on 22/12/22.
//

import Foundation
import SwiftUI

struct HomeInvoiceListView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("issued_invoices".localize.uppercased())
                .font(.mont(.semibold, size: 16))
                .padding(.bottom, Padding.medium)
            invoiceItem(icon: "icon_evos", title: "Evos", date: "15:30", amount: "50 000")
            invoiceItem(icon: "icon_evos", title: "Evos", date: "15:30", amount: "50 000")
            invoiceItem(icon: "icon_evos", title: "Evos", date: "15:30", amount: "50 000")
        }
        .padding(Padding.medium)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(Color.secondarySystemBackground)
        )
    }
    
    func invoiceItem(icon: String, title: String, date: String, amount: String) -> some View {
        VStack {
            HStack {
                Image("icon_evos")
                    .sizeToFit(height: 9.77)
                    .padding()
                    .background(
                        Circle()
                            .foregroundColor(Color.systemBackground)
                    )
                    .padding(.leading, -8)
                
                VStack(alignment: .leading) {
                    Text("Evos")
                        .font(.mont(.regular, size: 15))
                    Text("15:30")
                        .font(.mont(.regular, size: 12))
                        .foregroundColor(Color("dark_gray"))
                }
                
                Spacer()
                
                Text("50 000")
                    .font(.mont(.medium, size: 15))
            }
            
            Divider()
        }
    }
}

struct InvoiceListView_Preview: PreviewProvider {
    static var previews: some View {
        HomeInvoiceListView()
    }
}

