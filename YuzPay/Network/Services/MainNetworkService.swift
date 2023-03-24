//
//  MainNetworkService.swift
//  YuzPay
//
//  Created by applebro on 21/02/23.
//

import Foundation
import Combine

struct MainNetworkService: NetworkServiceProtocol {
    typealias S = MainNetworkServiceRoute
    
    public static var shared = MainNetworkService()
    
    func syncMerchantCategories() async -> Bool {
        let categories: NetRes<[NetResMerchantCategoryItem]>? = await Network.send(request: S.getCategories)
        categories?.data?.forEach({ cat in
            ObjectManager(MerchantCategoryManager()).add(cat)
        })
        return categories?.data?.nilIfEmpty != nil
    }
    
    func syncMerchants(forCategory category: Int, limit: Int? = nil, completion: @escaping (Bool) -> Void) {
        Task {
            let merchants: NetRes<[NetResMerchantItem]>? = await Network.send(request: S.getMerchants(byCategory: category, limit: limit))
            
            let merchantsList = merchants?.data?.compactMap({MerchantItemModel(id: "\($0.id)", title: $0.title, icon: $0.logo, categoryId: category)}) ?? []
            
            ObjectManager(MerchantManager()).addAll(merchantsList)
            
            DispatchQueue.main.async {
                completion(merchants?.success ?? false)
            }
        }
    }
    
    func searchMerchants(text: String, limit: Int = 20, completion: @escaping (Bool) -> Void) {
        Task {
            let merchants: NetRes<[NetResMerchantItem]>? = await Network.send(request: S.searchMerchants(text: text, limit: limit))
            
            let merchantsList = merchants?.data?.compactMap({MerchantItemModel(id: "\($0.id)", title: $0.title, icon: $0.logo, categoryId: $0.categoryId ?? 0)}) ?? []
            
            ObjectManager(MerchantManager()).addAll(merchantsList)
            
            DispatchQueue.main.async {
                completion(merchants?.success ?? false)
            }
        }
    }
    
    func syncInvoiceList() {
        Task {
            let invoiceList: NetRes<[NetResInvoiceItem]>? = await Network.send(request: S.getInvoiceList)
            ObjectManager(InvoiceManager()).addAll(invoiceList?.data?.compactMap({InvoiceItemModel.create(res:$0)}) ?? [])
        }
    }
}
