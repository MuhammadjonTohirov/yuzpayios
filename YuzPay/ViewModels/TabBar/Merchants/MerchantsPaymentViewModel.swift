//
//  MerchantsPaymentViewModel.swift
//  YuzPay
//
//  Created by applebro on 17/04/23.
//

import Foundation
import RealmSwift
import YuzSDK

enum MerchantPaymentRoute: String, Hashable {
    case payment
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

final class MerchantsPaymentViewModel: NSObject, ObservableObject, Loadable, Alertable {
    var alert: AlertToast = .init(displayMode: .alert, type: .regular)
    @Published var shouldShowAlert: Bool = false
    @Published var isLoading: Bool = false
    @Published var dismiss: Bool = false
    var merchantId: String
    @Published var route: MerchantPaymentRoute?

    @Published var showPaymentView = false
    @Published var selectedCard: DCard?
    @Published var formModel: FormModel?
    private var didAppear = false
    @Published var receiptItems: [ReceiptRowItem] = []
    
    var args: [String: String] = [:]
    
    var merchant: DMerchant? {
        let m = Realm.new?.object(ofType: DMerchant.self, forPrimaryKey: merchantId)
        if m?.isInvalidated ?? true {
            return nil
        } else {
            return m
        }
    }
        
    init(merchantId: String, args: [String: String] = [:]) {
        self.merchantId = merchantId
        self.args = args
        Logging.l(tag: "MerchantPayment", "Create merchant payment vm with \(args)")
    }
    
    func onAppear() {
        if !didAppear {
            didAppear = true
        }
    }
    
    func doPayment(cardId: String, formModel: FormModel?) {
        guard let formModel = formModel else { return }
        guard let serviceId = formModel.id else {
            return
        }
        
        
        let id = Int(merchantId) ?? 0
        let categoryId = merchant?.categoryId ?? 0
        
        self.showLoader()
        
        Task {
            var fields: [String: String] = [:]
            
            formModel.fields?.filter({$0.field.fieldRequired ?? false}).forEach({ f in
                var value = f.text
                
                if f.field.fieldType == .phone {
                    value = f.text.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
                }
                
                fields[f.field.name] = value
            })
            
            let details = await MainNetworkService.shared.doPayment(
                id: id,
                category: categoryId,
                payment: .init(cardId: Int(cardId)!, serviceId: serviceId, fields: fields)
            )
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                Logging.l("Payment result \(details.success)  \(details.error ?? "")")
                
                self.showPaymentStatus(formModel: formModel, details.success, details.error)
                self.hideLoader()
            }
        }
    }
    
    func onClickNext(formModel: FormModel?, completion: @escaping (Bool) -> Void) {
        let fields = formModel?.fields?.filter({$0.field.fieldRequired ?? false}) ?? []
        
        guard fields.allSatisfy( { field in
            !field.text.isEmpty
        }) else {
            completion(false)
            return
        }
        
        
        generateReceipt(formModel: formModel, fields)
        completion(true)
        route = .payment
    }
    
    func loadMerchantDetails() {
        guard let categoryId = merchant?.categoryId, let id = Int(merchantId) else {
            return
        }
        
        self.showLoader()
        
        DispatchQueue(label: "load", qos: .utility).asyncAfter(deadline: .now() + 0.5) {
            Task {
                if let details = await MainNetworkService.shared.getMerchantDetails(id: id, category: categoryId) {
                    DispatchQueue.main.async {
                        self.formModel = .create(with: details, args: self.args)
                    }
                }
                
                self.hideLoader()
            }
        }
    }
    
    func showPaymentStatus(formModel: FormModel?, _ isSuccess: Bool, _ error: String?) {
        showCustomAlert(alert: .init(displayMode: .alert, type: isSuccess ? .regular : .error(.systemRed), title: isSuccess ? "successfully_paid".localize : error ?? "error_in_payment".localize))
        if isSuccess {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                self.dismiss = true
            }
        }
    }
    
    private func generateReceipt(formModel: FormModel?, _ fields: [FieldItem]) {
        guard let merchant else {
            return
        }
        
        receiptItems.removeAll()
        receiptItems.append(.init(name: "category".localize, value: merchant.category?.title ?? ""))
        receiptItems.append(.init(name: "service".localize, value: merchant.title))
        receiptItems.append(.init(name: "date".localize, value: Date().toExtendedString(format: "dd.MM.YYYY")))
        
        fields.forEach { field in
            
            let rowType: ReceiptRowType = field.field.fieldType == .money ? .price : .regular
            let rowItem: ReceiptRowItem = .init(name: field.field.title ?? field.field.name, value: field.text, type: rowType)
            
            receiptItems.append(rowItem)
        }
        
        let comissionPercentage = formModel?.serviceCommission ?? 0
        receiptItems.append(.init(name: "commission".localize, value: "\(Int(comissionPercentage))"))
    }
}
