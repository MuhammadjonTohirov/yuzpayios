//
//  PaymentStatusView.swift
//  YuzPay
//
//  Created by applebro on 24/01/23.
//

import SwiftUI

class PaymentStatusViewModel: ObservableObject {
    var isSuccess: Bool = false

    var title: String
    
    var detail: String

    var onClickRetry: () -> Void
    var onClickFinish: () -> Void
    var onClickCancel: () -> Void
    
    init(isSuccess: Bool, title: String, details: String, onClickRetry: @escaping () -> Void, onClickFinish: @escaping () -> Void, onClickCancel: @escaping () -> Void) {
        self.isSuccess = isSuccess
        self.title = title
        self.detail = details
        self.onClickRetry = onClickRetry
        self.onClickFinish = onClickFinish
        self.onClickCancel = onClickCancel
    }
}

struct PaymentStatusView<Content: View>: View {
    @EnvironmentObject var viewModel: PaymentStatusViewModel
    @Environment(\.dismiss) var dismiss

    var image: () -> Content
        
    var body: some View {
        ZStack {
            VStack(spacing: 14) {
                image()
                    .foregroundColor(Color("accent"))
                Text(viewModel.title)
                    .mont(.semibold, size: 28)
                Text(viewModel.detail)
                    .multilineTextAlignment(.center)
                    .mont(.regular, size: 18)
            }
            .padding(.horizontal, Padding.default)

            VStack {
                Spacer()
                FlatButton(title: viewModel.isSuccess ? "finish".localize : "retry".localize, titleColor: .white) {
                    if viewModel.isSuccess {
                        dismiss()
                    }
                    
                    viewModel.isSuccess ? self.viewModel.onClickFinish() : self.viewModel.onClickRetry()
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color("accent"))
                )
                
                if !viewModel.isSuccess {
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
        PaymentStatusView() {
            Image("image_success_2")
                .renderingMode(.template)
                .resizable(true)
                .frame(width: 100, height: 100)
        }
        
        .environmentObject(PaymentStatusViewModel(isSuccess: true, title: "success", details: "transuccess", onClickRetry: {
            
        }, onClickFinish: {
            
        }, onClickCancel: {
            
        }))
    }
}
