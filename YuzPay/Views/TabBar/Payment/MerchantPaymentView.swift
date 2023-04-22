//
//  MerchantPaymentView.swift
//  YuzPay
//
//  Created by applebro on 24/01/23.
//

import SwiftUI
import RealmSwift

struct MerchantPaymentView: View {
    
    @StateObject var viewModel: MerchantsPaymentViewModel
    
    @State var amount: String = ""
    @State var phone: String = ""
    
    
    @State private var fields: [MField] = []
    
    @State private var maxAmount: Double = 0
    
    var body: some View {
        ZStack {
            NavigationLink("", isActive: $viewModel.showStatusView) {
                PaymentStatusView(title: "Success", detail: "Payment is successfull") {
                    Image("image_success_2")
                        .renderingMode(.template)
                        .resizable(true)
                        .frame(width: 100, height: 100)
                }
                .environmentObject(PaymentStatusViewModel(onClickRetry: {
                    
                }, onClickFinish: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        viewModel.showPaymentView = false
                    }
                }, onClickCancel: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        viewModel.showPaymentView = false
                    }
                }))
            }
            
            NavigationLink("", isActive: $viewModel.showPaymentView) {
                ReceiptAndPayView(rowItems: [
                    .init(name: "Receiver card number", value: "•••• 1212"),
                    .init(name: "Receiver name", value: "Master shifu"),
                    .init(name: "Date", value: "12.12.2023"),
                    .init(name: "Amount", value: "10 000 sum"),
                ], submitButtonTitle: "pay".localize) {                    
                    viewModel.doPayment()
                }
                .navigationTitle("transfer".localize)
            }
            
            if let m = viewModel.merchant {
                innerBody(m)
            } else if let formModel = viewModel.formModel {
                formModel.formView
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
        .loadable($viewModel.isLoading)
    }
    
    func innerBody(_ merchant: DMerchant) -> some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.secondarySystemBackground.opacity(0.5))
                .frame(width: 100, height: 100)
                .overlay {
                    KF(imageUrl: URL(string: merchant.icon))
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 80)
                        .background(Circle().foregroundColor(.systemBackground))
                }
                .padding(.top, Padding.default)
                .padding(.bottom, Padding.default)
            
            if let formModel = viewModel.formModel {
                formModel.formView
            }
            
            Spacer()
            
            HoverButton(title: "next".localize,
                        backgroundColor: Color.accentColor,
                        titleColor: .white,
                        isEnabled: true)
            {
                viewModel.showPaymentView = true
            }
            .padding(.horizontal, Padding.default)
            .padding(.bottom, Padding.medium)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(merchant.title)
    }    
}

struct MerchantPaymentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MerchantPaymentView(viewModel: .init(merchantId: "2"))
        }
    }
}
