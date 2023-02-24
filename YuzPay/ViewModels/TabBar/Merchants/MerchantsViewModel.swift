//
//  MerchantsViewModel.swift
//  YuzPay
//
//  Created by applebro on 23/02/23.
//

import Foundation
import RealmSwift
import SwiftUI

class MerchantsViewModel: NSObject, ObservableObject, Loadable, Alertable {
    var isLoading: Bool = false
    
    var alert: AlertToast = .init(type: .loading)
     
    var shouldShowAlert: Bool = false
    
    @Published var categories: Results<DMerchantCategory>?
    @Published var merchants: Results<DMerchant>?
    @Published var selectedMerchant: DMerchant?
    @Published var expandedCategory: Int?
    private var isViewAppeared = false
    private var catsNotification: NotificationToken?
    private var mersNotification: NotificationToken?
    
    override init() {
        super.init()
        Logging.l("MerchantsViewModel init")
    }
    
    func onAppear() {
        if !isViewAppeared {
            setupSubscribers()
            Logging.l("On appear merchantsviewmodel")
            isViewAppeared = true
        }
    }
    
    private func setupSubscribers() {
        
        invalidate()
        categories = Realm.new?.objects(DMerchantCategory.self)
        merchants = Realm.new?.objects(DMerchant.self)
        catsNotification = categories?.observe(on: .main, { [weak self] changes in
            switch changes {
            case let .update(items, _, _, _):
                withAnimation {
                    self?.categories = items
                }
                break
            default:
                break
            }
        })
        
        mersNotification = merchants?.observe(on: .main, { [weak self] changes in
            switch changes {
            case let .update(items, _, _, _):
                withAnimation {
                    self?.merchants = items
                }
                break
            default:
                break
            }
        })
        
        fetchMerchants()
    }
    
    func setSelected(merchant: DMerchant?) {
        self.selectedMerchant = merchant
    }
    
    private func invalidate() {
        catsNotification?.invalidate()
        mersNotification?.invalidate()
    }
    
    func expand(category: Int) {
        self.expandedCategory = category
    }
    
    func collapse() {
        self.expandedCategory = nil
    }
    
    deinit {
        invalidate()
        Logging.l("deinit merchantsviewmodel")
    }
    
    private func fetchMerchants() {
        Logging.l("Fetch merchats")
        DispatchQueue(label: "merchantLoader", qos: .utility).async {
            self.showLoader()

            guard let allCategories: Results<DMerchantCategory> = Realm.new?.objects(DMerchantCategory.self) else {
                return
            }
            
            let categoryIdList = allCategories.map({$0.id})
            
            let dispatchGroup = DispatchGroup()
            let dispatchSemaphore = DispatchSemaphore(value: 1)

            for id in categoryIdList {
                dispatchGroup.enter()
                MainNetworkService.shared.syncMerchants(forCategory: id, limit: 10) { _ in
                    dispatchGroup.leave()
                    dispatchSemaphore.signal()
                }
                dispatchSemaphore.wait()
            }
            
            dispatchGroup.notify(queue: .main) {
                self.hideLoader()
            }
        }
    }
}
