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
    var mersNotification: NotificationToken?
    private var category: DMerchantCategory?
    
    @Published var isLoading: Bool = false
    @Published var merchants: [DMerchant]?
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
        if category?.isInvalidated ?? false {
            return ""
        }
        
        return category?.title ?? ""
    }
    
    func setCategory(_ category: DMerchantCategory) {
        self.category = category
        self.setupSubscribers()
        self.fetchAllMerchants()
    }
    
    func onAppear() {
        if didAppear {
            return
        }
        
        didAppear = true
        
        if merchants == nil {
            self.setupSubscribers()
        }
    }
    
    func onDisappear() {
        self.merchants = nil
        self.merchantPaymentModel = nil
        Logging.l(tag: String(describing: AllMerchantsInCategoryViewModel.self), "On disappear \(id)")
    }
    
    private func fetchAllMerchants() {
        guard let category, !category.isInvalidated else {
            return
        }
        
        showLoader()
        MainNetworkService.shared.syncMerchants(forCategory: category.id, limit: nil) { [weak self] _ in
            self?.hideLoader()
        }
    }

    private func setupSubscribers() {
        guard let category, !category.isInvalidated else {
            return
        }
        
        invalidate()
        
        mersNotification = category.merchants?.observe(on: .main, { [weak self] changes in
            withAnimation {
                if let mrts = category.merchants, !mrts.isEmpty {
                    self?.merchants = mrts.compactMap({$0.isInvalidated ? nil : $0})
                }
            }
        })
    }
    
    func setSelected(merchant: DMerchant?) {
        guard let id = merchant?.id else {
            return
        }
        
        self.merchantPaymentModel = .init(merchantId: id)
    }
    
    func invalidate() {
        mersNotification?.invalidate()
    }
    
    deinit {
        Logging.l(tag: String(describing: AllMerchantsInCategoryViewModel.self), "Deinit \(id)")
    }
}
