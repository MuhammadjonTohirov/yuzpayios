//
//  PaymentStatusView.swift
//  YuzPay
//
//  Created by applebro on 24/01/23.
//

import SwiftUI

struct PaymentStatusView<Content: View>: View {
    var isSuccess: Bool = false
    
    var title: String
    
    var detail: String
    
    var image: () -> Content
    
    var onClickRetry: () -> Void
    
    var onClickCancel: () -> Void
    
    var onClickFinish: () -> Void
    
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
                    isSuccess ? self.onClickFinish() : self.onClickRetry()
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color("accent"))
                )
                
                if !isSuccess {
                    FlatButton(title: "cancel".localize, borderColor: .clear) {
                        self.onClickCancel()
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
        } onClickRetry: {
            
        } onClickCancel: {
            
        } onClickFinish: {
            
        }
    }
}
