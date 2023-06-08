//
//  OrderCardReceiptView.swift
//  YuzPay
//
//  Created by applebro on 02/01/23.
//

import SwiftUI
import RealmSwift

struct OrderCardReceiptView: View {
    
    @State var showPaymentStatusView = false
    @EnvironmentObject var viewModel: OrderCardViewModel
    var body: some View {
        ZStack {
            NavigationLink("", isActive: $showPaymentStatusView) {
                OrderCardPaymentStatusView(isSuccess: Bool.random())
                    .environmentObject(viewModel)

            }
            ReceiptAndPayView(rows: $viewModel.receiptRows)
                
                .set(submitButtonTitle: "transfer".localize)
                .set { cardId in
                    showPaymentStatusView = true
                }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("order_card".localize)
    }
}

struct OrderCardReceiptView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OrderCardReceiptView()
                .environmentObject(OrderCardViewModel())
        }
    }
}
