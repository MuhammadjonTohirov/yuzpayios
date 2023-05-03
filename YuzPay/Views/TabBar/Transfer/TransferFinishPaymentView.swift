//
//  TransferFinishPaymentView.swift
//  YuzPay
//
//  Created by applebro on 24/01/23.
//

import Foundation
import SwiftUI


struct TransferFinishPaymentView: View {
    @ObservedObject var viewModel: TransferViewModel = TransferViewModel()
    
    var body: some View {
        ReceiptAndPayView()
            .set(rows: [
                .init(name: "Receiver card number", value: "•••• 1212"),
                .init(name: "Receiver name", value: "Master shifu"),
                .init(name: "Date", value: "12.12.2023"),
                .init(name: "Amount", value: "10 000 sum"),
            ])
            .set(submitButtonTitle: "pay".localize)
            .set { cardId in
                
            }
    }
}

struct TransferFinishPaymentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TransferFinishPaymentView()
                .environmentObject(TransferViewModel())
        }
    }
}

