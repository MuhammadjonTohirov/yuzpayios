//
//  MainNetworkServiceRoute.swift
//  YuzPay
//
//  Created by applebro on 21/02/23.
//

import Foundation

enum MainNetworkServiceRoute: URLRequestProtocol {
    var url: URL {
        switch self {
        case .getCategories:
            return URL.base.appendingPath("api", "Client", "PaynetCategoryList")
        case let .getMerchants(cat, limit):
            if let l = limit {
                let url = URL.base.appendingPath("api", "Client", "PaynetProviderList", "\(cat)").queries(.init(name: "topRecords", value: "\(l)"))
                return url
            }
            return URL.base.appendingPath("api", "Client", "PaynetProviderList", "\(cat)")
        case let .searchMerchants(text, limit):
            return URL.base.appendingPath("api", "Client", "PaynetSearchProviders").queries(
                .init(name: "topRecords", value: "\(limit ?? 20)"),
                .init(name: "searchTerm", value: text)
            )
        case .getInvoiceList:
            return URL.base.appendingPath("api", "Client", "InvoiceList")
        case .getCardList:
            return URL.base.appendingPath("api", "Client", "CardList")
        case .addCard:
            return URL.base.appendingPath("api", "Client", "AddCard")
        case let .updateCard(id, _):
            return URL.base.appendingPath("api", "Client", "UpdateCard", "\(id)")
        case .deleteCard(let cardId):
            return URL.base.appendingPath("api", "Client", "DeleteCard", cardId)
        case let .getMerchantDetails(id, categoryId):
            return URL.base.appendingPath("api", "Client", "PaynetServiceList", categoryId, id)
        case let .confirmCard(cardId, _):
            return URL.base.appendingPath("api", "Client", "ConfirmCard", cardId)
        case let .doPayment(id, categoryId, _):
            return URL.base.appendingPath("api", "Client", "PaynetPerformService", categoryId, id)
        case .getTransactions:
            return URL.base.appendingPath("api", "Client", "CardTransactions")
        case let .doInvoicePayment(invoiceId, cardId):
            return URL.base.appendingPath("api", "Client", "ManuallyInvoice", invoiceId, cardId)
        case .getRegions:
            return URL.base.appendingPath("Handbook", "Regions")
        case let .getDistrict(regionId):
            return URL.base.appendingPath("Handbook", "Districts", regionId)
        case .orderCard:
            return URL.base.appendingPath("api", "Client", "OrderCard")
        }
    }
    
    var body: Data? {
        switch self {
        case let .addCard(card):
            return card.asData
        case let .updateCard(_, card):
            return card.asData
        case let .confirmCard(_, req):
            return req.asData
        case let .doPayment(_, _, req):
            return req.asData
        case let .orderCard(req):
            return req.asData
        default:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchMerchants, .addCard, .confirmCard, .doPayment, .doInvoicePayment, .orderCard:
            return .post
        case .updateCard:
            return .put
        case .deleteCard:
            return .delete
        default:
            return .get
        }
    }
    
    func request() -> URLRequest {
        var request = URLRequest.new(url: self.url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        return request
    }
    
    // MARK: - Merchants
    case getCategories
    case getMerchants(byCategory: Int, limit: Int?)
    case searchMerchants(text: String, limit: Int?)
    
    // MARK: - Invoice
    case getInvoiceList
    case doInvoicePayment(invoiceId: Int, cardId: Int)
    
    // MARK: - Card
    case getCardList
    case addCard(_ card: NetReqAddCard)
    case updateCard(_ id: Int, _ card: NetReqUpdateCard)
    case deleteCard(_ id: Int)
    case confirmCard(cardId: Int, _ request: NetReqConfirmAddCard)
    case orderCard(_ request: NetReqOrderCard)
    
    case getMerchantDetails(id: Int, categoryId: Int)
    case doPayment(id: Int, categoryId: Int, _ request: NetReqDoPayment)
    case getTransactions
    
    // MARK: - District and Regions
    case getRegions
    case getDistrict(regionId: Int)
}
