//
//  MerchantsViewModel.swift
//  YuzPay
//
//  Created by applebro on 23/02/23.
//

import Foundation
import RealmSwift
import SwiftUI
import YuzSDK

enum MerchantsViewRoute {
    case showAllMerchantsInCategory(category: DMerchantCategory)
    case showMerchant
}

class MerchantsViewModel: NSObject, ObservableObject, Loadable, Alertable {
    @Published var isLoading: Bool = false
    
    var alert: AlertToast = .init(type: .loading)
     
    var shouldShowAlert: Bool = false
    
    @Published var categories: Results<DMerchantCategory>?
    @Published var merchants: Results<DMerchant>?
    var selectedMerchant: String?
    var expandedCategory: Int?
    
    @Published var route: MerchantsViewRoute?
    
    private var isViewAppeared = false
    private var catsNotification: NotificationToken?
    private var mersNotification: NotificationToken?
    
    override init() {
        super.init()
        Logging.l("MerchantsViewModel init")
    }
    
    func onAppear() {

        if isViewAppeared {
            return
        }
        
        Logging.l("On appear merchantsviewmodel")
        isViewAppeared = true
        fetchMerchants()
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        invalidate()
        Realm.asyncNew { result in
            if let realm = result.successValue {
                autoreleasepool {
                    self.catsNotification = realm.objects(DMerchantCategory.self).observe(on: .main, { [weak self] changes in
                        switch changes {
                        case let .update(items, _, _, _):
                            withAnimation {
                                self?.categories = items
                            }
                            break
                        case let .initial(items):
                            self?.categories = items
                        default:
                            break
                        }
                    })
                    
                    self.mersNotification = realm.objects(DMerchant.self).observe(on: .main, { [weak self] changes in
                        switch changes {
                        case let .update(items, _, _, _):
                            withAnimation {
                                self?.merchants = items
                            }
                            break
                        case let .initial(items):
                            self?.merchants = items
                        default:
                            break
                        }
                    })
                }
            }
        }
    }
    
    func setSelected(merchant: DMerchant?) {
        self.selectedMerchant = merchant?.id
    }
    
    func setSelected(merchantId id: String) {
        if self.selectedMerchant != id {
            self.selectedMerchant = id
        }
    }
    
    private func invalidate() {
        catsNotification?.invalidate()
        mersNotification?.invalidate()
    }
    
    func expand(category: Int) {
        self.expandedCategory = category
    }
    
    func onDisappear() {
        invalidate()
        categories = nil
        merchants = nil
    }
    
    func collapse() {
        self.expandedCategory = nil
    }
    
    deinit {
        invalidate()
        Logging.l("deinit merchantsviewmodel")
    }
    
    func searchMerchant(withName name: String) {
        // filter merchants if name count is more than 3 character, do nothing
        // if name is empty, show all merchants
        // do all of them in background thread
        MainNetworkService.shared.searchMerchants(text: name) { result in
            Logging.l(tag: "MerchantesView", "Search for \(name) is \(result)")
        }
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
