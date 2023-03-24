//
//  AllMerchantsInCategoryViewModel.swift
//  YuzPay
//
//  Created by applebro on 24/02/23.
//

import SwiftUI
import RealmSwift

class AllMerchantsInCategoryViewModel: NSObject, ObservableObject, Loadable {
    var mersNotification: NotificationToken?
    private var category: DMerchantCategory?
    @Published var isLoading: Bool = false
    @Published var merchants: Results<DMerchant>?
    @Published var selectedMerchant: DMerchant?
    
    private var didAppear: Bool = false
    private var id: String
    override init() {
        self.id = UUID().uuidString
        super.init()
        Logging.l(tag: String(describing: AllMerchantsInCategoryViewModel.self), "Init \(id)")
    }
    
    var title: String {
        category?.title ?? ""
    }
    
    func setCategory(_ category: DMerchantCategory) {
        self.category = category
        self.setupSubscribers()
        self.fetchAllMerchants()
    }
    
    func onAppear() {
        if merchants == nil {
            self.setupSubscribers()
        }
    }
    
    func onDisappear() {
        self.merchants = nil
        self.selectedMerchant = nil
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

    private func setupSubscribers() {
        guard let category else {
            return
        }
        
        invalidate()
        
        mersNotification = category.merchants?.observe(on: .main, { [weak self] changes in
            withAnimation {
                if let mrts = category.merchants, !mrts.isEmpty {
                    self?.merchants = mrts
                }
            }
        })
    }
    
    func setSelected(merchant: DMerchant?) {
        self.selectedMerchant = merchant
    }
    
    func invalidate() {
        mersNotification?.invalidate()
    }
    
    deinit {
        Logging.l(tag: String(describing: AllMerchantsInCategoryViewModel.self), "Deinit \(id)")
    }
}
