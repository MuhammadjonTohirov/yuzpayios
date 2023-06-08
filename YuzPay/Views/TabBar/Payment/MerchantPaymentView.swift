//
//  MerchantPaymentView.swift
//  YuzPay
//
//  Created by applebro on 24/01/23.
//

import SwiftUI
import RealmSwift
import YuzSDK

struct MerchantPaymentView: View {
    
    @StateObject var viewModel: MerchantsPaymentViewModel = .init(merchantId: "1")
    @EnvironmentObject var tabModel: TabViewModel
    @EnvironmentObject var alertModel: MainAlertModel
    
    @State private var fields: [MField] = []
    
    @State private var maxAmount: Double = 0
    
    @State var merchantId: String
    @State var args: [String: String]
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            
            if let m = viewModel.merchant {
                innerBody(m)
            } else if let formModel = viewModel.formModel {
                formModel
                    .formView
                    .transaction { transition in
                        transition.animation = nil
                    }
            }
        }
        .sheet(unwrapping: $viewModel.route, content: { _ in
            NavigationView(content: {
                ReceiptAndPayView(rows: $viewModel.receiptItems)
                    .set(submitButtonTitle: "pay".localize)
                    .set(showCards: true)
                    .set(filter: { card in
                        card.isLocalCard
                    })
                    .set { cardId in
                        viewModel.doPayment(cardId: cardId, formModel: viewModel.formModel)
                    }
                    .navigationTitle("transfer".localize)
            })
        })
        .onAppear {
            self.viewModel.merchantId = merchantId
            self.viewModel.args = args
            
            viewModel.onAppear()
            loadDetails()
        }
        .loadable($viewModel.isLoading)
        .onChange(of: viewModel.dismiss) { newValue in
            if newValue {
                dismiss()
            }
        }
        .toast($viewModel.shouldShowAlert, viewModel.alert, duration: 1)
        .onChange(of: viewModel.shouldShowAlert) { newValue in
            if newValue {
                UIApplication.shared.endEditing()
            }
        }
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
                viewModel.onClickNext(formModel: viewModel.formModel) { isSatisfy in
                    if !isSatisfy {
                        alertModel.show(title: "warning".localize, message: "fill_all_fileds".localize)
                    }
                }
            }
            .padding(.horizontal, Padding.default)
            .padding(.bottom, Padding.medium)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(merchant.title)
    }
    
    private func loadDetails() {
        Logging.l("Load details for \(merchantId) with \(args)")
        viewModel.loadMerchantDetails()
    }
}

struct MerchantPaymentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MerchantPaymentView(merchantId: "44", args: [:])
        }
    }
}
