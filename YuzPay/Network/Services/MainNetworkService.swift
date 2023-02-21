//
//  MainNetworkService.swift
//  YuzPay
//
//  Created by applebro on 21/02/23.
//

import Foundation

struct MainNetworkService {
    typealias S = MainNetworkServiceRoute
    
    public static var shared = MainNetworkService()
    
    func syncMerchantCategories() async -> Bool {
        let categories: NetRes<[NetResMerchantCategoryItem]>? = await Network.send(request: S.getCategories);
        categories?.data?.forEach({ cat in
            ObjectManager(MerchantCategoryManager()).add(cat)
        })
        return categories?.data?.nilIfEmpty != nil
    }
}
