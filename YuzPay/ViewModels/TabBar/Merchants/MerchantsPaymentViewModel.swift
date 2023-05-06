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

final class MerchantsPaymentViewModel: NSObject, ObservableObject, Loadable {
    @Published var isLoading: Bool = false
    private(set) var paymentStatusViewModel: PaymentStatusViewModel?
    var merchantId: String
    @Published var route: MerchantPaymentRoute?
    @Published var showStatusView = false
    @Published var showPaymentView = false
    @Published var selectedCard: DCard?
    @Published var formModel: FormModel?

    private var didAppear = false
    private(set) var receiptItems: [ReceiptRowItem] = []
    
    var merchant: DMerchant? {
        let m = Realm.new?.object(ofType: DMerchant.self, forPrimaryKey: merchantId)
        if m?.isInvalidated ?? true {
            return nil
        } else {
            return m
        }
    }
        
    init(merchantId: String) {
        self.merchantId = merchantId
        Logging.l(tag: "MerchantPayment", "Create merchant payment vm")
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
            
//            #if DEBUG
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                self.showPaymentStatus(formModel: formModel, true, nil)
//                self.hideLoader()
//            }
//            #else
            let details = await MainNetworkService.shared.doPayment(
                id: id,
                category: categoryId,
                payment: .init(cardId: Int(cardId)!, serviceId: serviceId, fields: fields)
            )
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                Logging.l("Payment result \(details.success)  \(details.error ?? "")")
                
                self.showPaymentStatus(formModel: formModel, details.success, details.error)//(details.success, details.error)
                self.hideLoader()
            }
//            #endif
            
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
    
    func showPaymentStatus(formModel: FormModel?, _ isSuccess: Bool, _ error: String?) {
        let title = formModel?.title ?? "payment".localize
        let details = isSuccess ? "Successful payment" : error ?? "Payment failed"
        paymentStatusViewModel = .init(
            isSuccess: isSuccess, title: title,
            details: details,
            onClickRetry: {
                
            }, onClickFinish: { [weak self] in
                self?.hidePaymentStatus()
            }, onClickCancel: { [weak self] in
                self?.hidePaymentStatus()
            }
        )
        showStatusView = true
    }
    
    private func hidePaymentStatus() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.showStatusView = false
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
