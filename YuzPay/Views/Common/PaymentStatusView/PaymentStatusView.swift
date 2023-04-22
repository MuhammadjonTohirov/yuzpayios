//
//  PaymentStatusView.swift
//  YuzPay
//
//  Created by applebro on 24/01/23.
//

import SwiftUI

class PaymentStatusViewModel: ObservableObject {
    var onClickRetry: () -> Void
    var onClickFinish: () -> Void
    var onClickCancel: () -> Void
    
    init(onClickRetry: @escaping () -> Void, onClickFinish: @escaping () -> Void, onClickCancel: @escaping () -> Void) {
        self.onClickRetry = onClickRetry
        self.onClickFinish = onClickFinish
        self.onClickCancel = onClickCancel
    }
}

struct PaymentStatusView<Content: View>: View {
    @EnvironmentObject var viewModel: PaymentStatusViewModel
    @Environment(\.dismiss) var dismiss
    var isSuccess: Bool = false
    
    var title: String
    
    var detail: String
    
    var image: () -> Content
        
    var body: some View {
        ZStack {
            VStack(spacing: 14) {
                image()
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
                    if isSuccess {
                        dismiss()
                    }
                    
                    isSuccess ? self.viewModel.onClickFinish() : self.viewModel.onClickRetry()
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color("accent"))
                )
                
                if !isSuccess {
                    FlatButton(title: "cancel".localize, borderColor: .clear) {
                        self.viewModel.onClickCancel()
                        
                        dismiss()
                    }
                }
            }
            .padding(.bottom, Padding.medium)
            .padding(.horizontal, Padding.large)
        }
    }
}

struct PaymentStatusView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentStatusView(isSuccess: true, title: "Success", detail: "Payment status is OK") {
            Image("image_success_2")
                .renderingMode(.template)
                .resizable(true)
                .frame(width: 100, height: 100)
        }
        
        .environmentObject(PaymentStatusViewModel(onClickRetry: {
            
        }, onClickFinish: {
            
        }, onClickCancel: {
            
        }))
    }
}
