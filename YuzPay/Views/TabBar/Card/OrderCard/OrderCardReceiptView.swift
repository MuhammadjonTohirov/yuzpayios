//
//  OrderCardReceiptView.swift
//  YuzPay
//
//  Created by applebro on 02/01/23.
//

import SwiftUI
import SwiftUIX
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
            
            ReceiptAndPayView(rowItems: [
                .init(name: "Карта:", value: "Uzcard от Anor Bank"),
                .init(name: "Будет доставлена:", value: "через 14 дней"),
                .init(name: "Адрес доставки:", value: "Мирабадский р-н, 17, 5"),
                .init(name: "Стоимость выпуска:", value: "30 000 сум"),
                .init(name: "Стоимость доставки:", value: "10 000 сум"),
                .init(name: "Общая стоимость:", value: "40 000 сум")
            ], submitButtonTitle: "transfer".localize) {
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
