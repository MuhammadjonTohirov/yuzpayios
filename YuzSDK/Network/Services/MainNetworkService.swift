//
//  MainNetworkService.swift
//  YuzPay
//
//  Created by applebro on 21/02/23.
//

import Foundation
import Combine



public struct MainNetworkService: NetworkServiceProtocol {
    typealias S = MainNetworkServiceRoute
    
    public static var shared = MainNetworkService()
    
    // - MARK: Merchants
    
    public func syncMerchantCategories() async -> Bool {
        let categories: NetRes<[NetResMerchantCategoryItem]>? = await Network.send(request: S.getCategories)
        categories?.data?.forEach({ cat in
            ObjectManager(MerchantCategoryManager()).add(cat)
        })
        return categories?.data?.nilIfEmpty != nil
    }
    
    public func syncMerchants(forCategory category: Int, limit: Int? = nil, completion: @escaping (Bool) -> Void) {
        Task {
            let merchants: NetRes<[NetResMerchantItem]>? = await Network.send(request: S.getMerchants(byCategory: category, limit: limit))
            
            let merchantsList = merchants?.data?.compactMap({MerchantItemModel(id: "\($0.id)", title: $0.title, icon: $0.logo, categoryId: category)}) ?? []
            
            ObjectManager(MerchantManager()).addAll(merchantsList)
            
            DispatchQueue.main.async {
                completion(merchants?.success ?? false)
            }
        }
    }
    
    public func searchMerchants(text: String, limit: Int = 20, completion: @escaping (Bool) -> Void) {
        Task {
            let merchants: NetRes<[NetResMerchantItem]>? = await Network.send(request: S.searchMerchants(text: text, limit: limit))
            
            let merchantsList = merchants?.data?.compactMap({MerchantItemModel(id: "\($0.id)", title: $0.title, icon: $0.logo, categoryId: $0.categoryId ?? 0)}) ?? []
            
            ObjectManager(MerchantManager()).addAll(merchantsList)
            
            DispatchQueue.main.async {
                completion(merchants?.success ?? false)
            }
        }
    }
    
    public func syncInvoiceList() {
        Task {
            let invoiceList: NetRes<[NetResInvoiceItem]>? = await Network.send(request: S.getInvoiceList)
            ObjectManager(InvoiceManager()).addAll(invoiceList?.data?.compactMap({InvoiceItemModel.create(res:$0)}) ?? [])
        }
    }
    
    public func getMerchantDetails(id: Int, category: Int) async -> NetResMerchantDetails? {
        let result: NetRes<[NetResMerchantDetails]>? = await Network.send(request: S.getMerchantDetails(id: id, categoryId: category))
        return result?.data?.first
    }
 
    // - MARK: Cards
    
    public func syncCardList() {
        Task {
            let cardList: NetRes<[NetResCardItem]>? = await Network.send(request: S.getCardList)
            ObjectManager(CreditCardManager()).addAll(cardList?.data?.compactMap({CardModel.create(res:$0)}) ?? [])
        }
    }
    
    public func addCard(card: NetReqAddCard) async -> (success: NetResAddCard?, error: String?) {
        let res: NetRes<NetResAddCard>? = await Network.send(request: S.addCard(card))
        return (res?.data, res?.error)
    }
    
    public func confirmCard(cardId: Int, card: NetReqConfirmAddCard) async -> (result: NetResCardItem?, error: String?) {
        let res: NetRes<NetResCardItem>? = await Network.send(request: S.confirmCard(cardId: cardId, card))
        return (res?.data, res?.error)
    }
    
    public func updateCard(cardId: Int, card: NetReqUpdateCard) async -> (success: Bool, error: String?) {
        let res: NetRes<String>? = await Network.send(request: S.updateCard(cardId, card))
        return (res?.success ?? false, res?.error)
    }
    
    public func deleteCard(cardId: String) async -> (success: Bool, error: String?) {
        let res: NetRes<String>? = await Network.send(request: S.deleteCard(Int(cardId)!))
        return (res?.success ?? false, res?.error)
    }
    
    // - MARK: Payment for merhcnats
    public func doPayment(id: Int, category: Int, payment: NetReqDoPayment) async -> (success: Bool, error: String?) {
        Logging.l(payment.asString)
        let res: NetRes<String>? = await Network.send(request: S.doPayment(id: id, categoryId: category, payment))
        return (res?.success ?? false, res?.error)
    }
    
    // - MARK: Transactions
    public func syncTransactions() {
        Task(priority: .medium) {
            let result: NetRes<[NetResTransactionItem]>? = await Network.send(request: MainNetworkServiceRoute.getTransactions)
            result?.data?.forEach({ item in
                ObjectManager(TransactionsManager()).add(TransactionItem.fromNetResTransactionItem(item))
            })
        }
    }
    
    public func doInvoicePayment(invoiceId: Int, cardId: Int) async -> (success: Bool, error: String?) {
        let result: NetRes<String>? = await Network.send(request: S.doInvoicePayment(invoiceId: invoiceId, cardId: cardId))
        InvoiceManager().set(isPaid: result?.success ?? false, invoiceId: invoiceId)
        return (result?.success ?? false, result?.error)
    }
    
    public func orderCard(req: NetReqOrderCard) async -> Bool {
        let result: NetRes<String>? = await Network.send(request: S.orderCard(req))
        return result?.success ?? false
    }
    
    public func orderVirtualCard(req: NetReqOrderVirtualCard) async -> Bool {
        let result: NetRes<NetResCardItem>? = await Network.send(request: S.orderVirtualCard(req))
        if let data = result?.data {
            CreditCardManager.shared.add(CardModel.create(res: data))
        }
        return result?.success ?? false
    }
    
    // MARK: - Handbook
    public func getRegions() async -> NetRes<[NetResRegion]>? {
        return await Network.send(request: S.getRegions)
    }
    
    public func getDistricts(_ regionId: Int) async -> NetRes<[NetResDistrict]>? {
        return await Network.send(request: S.getDistrict(regionId: regionId))
    }
    
    /// loads exchange rates and stores to database
    public func syncExchangeRate() async {
        if let objects: NetRes<[NetResExchangeRate]> = await Network.send(request: S.getExchangeRate) {
            CommonDbManager.shared.insertExchangeRates(objects.data ?? [])
        }
    }
    
    // MARK: - P2P
    public func findCard(with cardNumber: String) async -> NetResCardItem? {
        return await Network.send(request: S.findCard(cardNumber: cardNumber))?.data
    }
    
    /// gets card details
    public func getCard(id cardId: String) async -> NetResCardItem? {
        return await Network.send(request: S.getCard(id: cardId))?.data
    }
    
    /// p2p
    public func p2pTransfer(cardId: String, req: NetReqP2P) async -> (Bool, String?) {
        let result: NetRes<String>? = await Network.send(request: S.p2p(cardId: cardId, req: req))
        return (result?.error == nil, result?.error)
    }
    
    /// uzs to usd or vice versa
    public func exchange(cardId: String, req: NetReqExchange) async -> (Bool, String?) {
        let result: NetRes<String>? = await Network.send(request: S.echange(cardId: cardId, req: req))
        return (result?.error == nil, result?.error)
    }
    
    public func syncSavedCards() {
        Task {
            let cardList: NetRes<[NetResCardItem]>? = await Network.send(request: S.savedCards)
            CreditCardManager().addSavedCards(cardList?.data?.compactMap({
                CardModel.create(res:$0)
            }) ?? [])
        }
    }
}

