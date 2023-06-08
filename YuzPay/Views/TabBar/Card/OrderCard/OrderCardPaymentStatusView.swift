//
//  OrderCardPaymentStatusView.swift
//  YuzPay
//
//  Created by applebro on 03/01/23.
//

import SwiftUI

struct OrderCardPaymentStatusView: View {
    var isSuccess: Bool = false
    @EnvironmentObject var viewModel: OrderCardViewModel
    
    private var title: String {
        isSuccess ? "card_order_success".localize : "card_order_failure".localize
    }
    
    private var detail: String {
        isSuccess ? "card_order_success_detail".localize : "card_order_failure_detail".localize
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 14) {
                Image(isSuccess ? "image_success_order_card" : "image_failure_order_card")
                    .renderingMode(.template)
                    .foregroundColor(Color("accent"))
                Text(title)
                    .mont(.semibold, size: 28)
                Text(detail)
                    .multilineTextAlignment(.center)
                    .mont(.regular, size: 18)
            }
            .padding(.horizontal, Padding.default)

            VStack {
                Spacer()
                FlatButton(title: isSuccess ? "finish".localize : "retry".localize, titleColor: .white) {
                    viewModel.dismiss()
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color("accent"))
                )
                
                if !isSuccess {
                    FlatButton(title: "cancel".localize, borderColor: .clear) {
                        
                    }
                }
            }
            .padding(.bottom, Padding.medium)
            .padding(.horizontal, Padding.large)
        }
    }
}

struct OrderCardPaymentStatusView_Previews: PreviewProvider {
    static var previews: some View {
        OrderCardPaymentStatusView()
    }
}
