//
//  AllMerchantsInCategoryViewModel.swift
//  YuzPay
//
//  Created by applebro on 24/02/23.
//

import SwiftUI
import RealmSwift
import YuzSDK

enum AllMerchantsRoute {
    case showPayment
}

class AllMerchantsInCategoryViewModel: NSObject, ObservableObject, Loadable {
    private var category: (title: String, id: Int)?
    
    @Published var isLoading: Bool = false
    @Published var route: AllMerchantsRoute?
    
    @Published private(set) var merchantPaymentModel: MerchantsPaymentViewModel? {
        didSet {
            Logging.l(tag: "AllMerchants", "set merchant payment model \(merchantPaymentModel?.merchantId ?? "")")
        }
    }
    
    private var didAppear: Bool = false
    private var id: String
    
    override init() {
        self.id = UUID().uuidString
        super.init()
        Logging.l(tag: String(describing: AllMerchantsInCategoryViewModel.self), "Init \(id)")
    }
    
    var title: String {
        return category?.title ?? ""
    }
    
    func setCategory(_ category: (title: String, id: Int)) {
        self.category = category
        self.fetchAllMerchants()
    }
    
    func onAppear() {
        if didAppear {
            return
        }
        
        didAppear = true
    }
    
    func onDisappear() {
        self.merchantPaymentModel = nil
        Logging.l(tag: String(describing: AllMerchantsInCategoryViewModel.self), "On disappear \(id)")
    }
    
    private func fetchAllMerchants() {
        guard let category else {
            return
        }
        
        showLoader()
        MainNetworkService.shared.syncMerchants(forCategory: category.id, limit: nil) { [weak self] _ in
            self?.hideLoader()
        }
    }

    func setSelected(merchant: DMerchant?) {
        guard let id = merchant?.id else {
            return
        }
        
        self.merchantPaymentModel = .init(merchantId: id)
    }
    
    func invalidate() {
//        mersNotification?.invalidate()
    }
    
    deinit {
        Logging.l(tag: String(describing: AllMerchantsInCategoryViewModel.self), "Deinit \(id)")
    }
}
