//
//  TransferFinishPaymentView.swift
//  YuzPay
//
//  Created by applebro on 24/01/23.
//

import Foundation
import SwiftUI


struct TransferFinishPaymentView: View {
    @ObservedObject var viewModel: TransferToCardViewModel = TransferToCardViewModel()
    @State var receiptRows: [ReceiptRowItem] = []
    var body: some View {
        ReceiptAndPayView(rows: $receiptRows)
            .set(submitButtonTitle: "pay".localize)
            .set { cardId in
                
            }
    }
}

struct TransferFinishPaymentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TransferFinishPaymentView()
                .environmentObject(TransferToCardViewModel())
        }
    }
}

