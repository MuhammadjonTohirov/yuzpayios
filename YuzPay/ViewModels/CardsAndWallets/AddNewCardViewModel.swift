//
//  AddNewCardViewModel.swift
//  YuzPay
//
//  Created by applebro on 26/12/22.
//

import Foundation

final class AddNewCardViewModel: ObservableObject {
    
    @Published var cardNumber: String = ""
    @Published var expireDate: String = ""
    @Published var cardName: String = ""
    @Published var scanCard = false
    @Published var isActive = false
    
    init(cardNumber: String = "", expireDate: String = "", cardName: String = "", scanCard: Bool = false) {
        self.cardNumber = cardNumber
        self.expireDate = expireDate
        self.cardName = cardName
        self.scanCard = scanCard
        
        Logging.l("Init add new card view model")
    }
    
    func onClickScanCard() {
        scanCard = true
    }
    
    func reloadView() {
        isActive = !cardNumber.isEmpty && !expireDate.isEmpty && !cardName.isEmpty
    }
    
    func addNewCard() {
        CreditCardManager.shared.add(
            .init(id: UUID().uuidString,
                  cardNumber: cardNumber.maskAsCardNumber,
                  expirationDate: Date.cardExpireDateToDateObject(expireDate) ?? Date(),
                  name: cardName.isEmpty ? "A card name" : cardName,
                  isMain: false, cardType: .visa, status: .active, moneyAmount: 800)
        )
    }
    
    deinit {
        Logging.l("Deinit add new card view model")
    }
}
