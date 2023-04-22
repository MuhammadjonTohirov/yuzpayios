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
    
    // - MARK: Merchants
    
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
    
    func getMerchantDetails(id: Int, category: Int) async -> NetResMerchantDetails? {
        let result: NetRes<[NetResMerchantDetails]>? = await Network.send(request: S.getMerchantDetails(id: id, categoryId: category))
        return result?.data?.first
    }
 
    // - MARK: Cards
    
    func syncCardList() {
        Task {
            let cardList: NetRes<[NetResCardItem]>? = await Network.send(request: S.getCardList)
            ObjectManager(CreditCardManager()).addAll(cardList?.data?.compactMap({CardModel.create(res:$0)}) ?? [])
        }
    }
    
    func addCard(card: NetReqAddCard) async -> (success: NetResAddCard?, error: String?) {
        let res: NetRes<NetResAddCard>? = await Network.send(request: S.addCard(card))
        return (res?.data, res?.error)
    }
    
    func confirmCard(cardId: Int, card: NetReqConfirmAddCard) async -> (result: NetResCardItem?, error: String?) {
        let res: NetRes<NetResCardItem>? = await Network.send(request: S.confirmCard(cardId: cardId, card))
        return (res?.data, res?.error)
    }
    
    func updateCard(cardId: Int, card: NetReqUpdateCard) async -> (success: Bool, error: String?) {
        let res: NetRes<String>? = await Network.send(request: S.updateCard(cardId, card))
        return (res?.success ?? false, res?.error)
    }
    
    func deleteCard(cardId: String) async -> (success: Bool, error: String?) {
        let res: NetRes<String>? = await Network.send(request: S.deleteCard(Int(cardId)!))
        return (res?.success ?? false, res?.error)
    }
    
    func doPayment(id: Int, category: Int, payment: NetReqDoPayment) async -> (success: Bool, error: String?) {
        let res: NetRes<String>? = await Network.send(request: S.doPayment(id: id, categoryId: category, payment))
        return (res?.success ?? false, res?.error)
    }
}
