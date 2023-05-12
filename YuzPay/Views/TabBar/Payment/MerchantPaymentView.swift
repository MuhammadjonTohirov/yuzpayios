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
    
    @ObservedObject var viewModel: MerchantsPaymentViewModel
    @EnvironmentObject var tabModel: TabViewModel
    @EnvironmentObject var alertModel: MainAlertModel
    
    @State var amount: String = ""
    @State var phone: String = ""
    
    @State private var fields: [MField] = []
    
    @State private var maxAmount: Double = 0

    init(viewModel: MerchantsPaymentViewModel) {
        self.viewModel = viewModel
    }
    
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
        .sheet(isPresented: $viewModel.showStatusView, content: {
            NavigationView {
                if let vm = viewModel.paymentStatusViewModel {
                    PaymentStatusView() {
                        Image("image_success_2")
                            .renderingMode(.template)
                            .resizable(true)
                            .frame(width: 100, height: 100)
                    }
                    .environmentObject(vm)
                } else {
                    Text("")
                }
            }
        })
        .sheet(unwrapping: $viewModel.route, content: { _ in
            NavigationView(content: {
                ReceiptAndPayView(rows: $viewModel.receiptItems)
                    
                    .set(submitButtonTitle: "pay".localize)
                    .set(showCards: true)
                    .set { cardId in
                        viewModel.doPayment(cardId: cardId, formModel: viewModel.formModel)
                    }
                    .navigationTitle("transfer".localize)
            })
        })
        .onAppear {
            viewModel.onAppear()
            loadDetails()
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
                viewModel.onClickNext(formModel: viewModel.formModel) { isSatisfy in
                    if !isSatisfy {
                        alertModel.show(title: "warning".localize, message: "You should fill all fields")
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
        let categoryId = viewModel.merchant?.categoryId ?? 0
        let id = Int(viewModel.merchantId) ?? 0
        self.viewModel.showLoader()
        DispatchQueue(label: "load", qos: .utility).asyncAfter(deadline: .now() + 0.2) {
            Task {
                if let details = await MainNetworkService.shared.getMerchantDetails(id: id, category: categoryId) {
                    DispatchQueue.main.async {
                        self.viewModel.formModel = .create(with: details)
                    }
                }
                
                self.viewModel.hideLoader()
            }
        }
    }
}

struct MerchantPaymentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MerchantPaymentView(viewModel: .init(merchantId: "44"))
        }
    }
}
