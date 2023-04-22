//
//  MerchantsPaymentViewModel.swift
//  YuzPay
//
//  Created by applebro on 17/04/23.
//

import Foundation
import RealmSwift

final class MerchantsPaymentViewModel: NSObject, ObservableObject, Loadable {
    @Published var isLoading: Bool = false
    
    var merchantId: String
    
    @Published var showStatusView = false
    @Published var showPaymentView = false

    var merchant: DMerchant? {
        Realm.new?.object(ofType: DMerchant.self, forPrimaryKey: merchantId)
    }

    @Published var formModel: FormModel?
    
    init(merchantId: String, formModel: FormModel? = nil) {
        self.merchantId = merchantId
        self.formModel = formModel
    }
    
    func onAppear() {
        loadDetails()
    }
    
    private func loadDetails() {
        let categoryId = merchant?.categoryId ?? 0
        let id = Int(merchantId) ?? 0
        self.showLoader()
        DispatchQueue(label: "load", qos: .utility).asyncAfter(deadline: .now() + 0.2) {
            Task {
                if let details = await MainNetworkService.shared.getMerchantDetails(id: id, category: categoryId) {
                    DispatchQueue.main.async {
                        self.formModel = .create(with: details)
                    }
                    self.hideLoader()
                } else {
                    self.hideLoader()
                }
            }
        }
    }
    
    func doPayment() {
        guard let formModel = formModel else { return }
        let id = Int(merchantId) ?? 0
        let categoryId = merchant?.categoryId ?? 0
        self.showLoader()
        
        Task {
            var fields: [String: String] = [:]
            
            formModel.fields?.forEach({ f in
                var value = f.text
                
                if f.field.fieldType == .phone {
                    value = f.text.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
                }
                
                fields[f.field.name] = value
            })
        
            let details = await MainNetworkService.shared.doPayment(id: id,
                                                                    category: categoryId,
                                                                    payment: .init(
                                                                        cardId: 0, serviceId: id,
                                                                        fields: fields))
            
            DispatchQueue.main.async {
                Logging.l("Payment result \(details.success)  \(details.error ?? "")")
            }
            self.hideLoader()
            
        }
    }
}
