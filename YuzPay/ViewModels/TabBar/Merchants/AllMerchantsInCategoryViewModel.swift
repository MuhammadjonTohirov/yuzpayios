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
    private var category: DMerchantCategory
    @Published var isLoading: Bool = false
    @Published var merchants: Results<DMerchant>?
    @Published var selectedMerchant: DMerchant?
    private var didAppear: Bool = false
    var title: String {
        category.title
    }
    
    init(category: DMerchantCategory) {
        self.category = category
    }
    
    func onAppear() {
        if !didAppear {
            self.setupSubscribers()
            self.fetchAllMerchants()
            self.didAppear = true
        }
    }
    
    private func fetchAllMerchants() {
        showLoader()
        MainNetworkService.shared.syncMerchants(forCategory: category.id, limit: nil) { [weak self] _ in
            self?.hideLoader()
        }
    }

    private func setupSubscribers() {
        invalidate()
        
        mersNotification = category.merchants?.observe(on: .main, { [weak self] changes in
            withAnimation {
                self?.merchants = self?.category.merchants
            }
        })
    }
    
    func setSelected(merchant: DMerchant?) {
        self.selectedMerchant = merchant
    }
    
    func invalidate() {
        mersNotification?.invalidate()
    }
}
