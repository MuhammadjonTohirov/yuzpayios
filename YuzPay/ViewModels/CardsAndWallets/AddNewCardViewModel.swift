//
//  AddNewCardViewModel.swift
//  YuzPay
//
//  Created by applebro on 26/12/22.
//

import Foundation

final class AddNewCardViewModel: NSObject, ObservableObject, Loadable, Alertable {
    @Published var isLoading: Bool = false
    
    @Published var alert: AlertToast = .init(displayMode: .alert, type: .loading)
    
    @Published var shouldShowAlert: Bool = false
    
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
    
    func addNewCard(completion: @escaping () -> Void) {
        self.showLoader()
        
        DispatchQueue.init(label: "add_card", qos: .utility).async {
            sleep(2)
            CreditCardManager.shared.add(
                .init(id: UUID().uuidString,
                      cardNumber: self.cardNumber.maskAsCardNumber,
                      expirationDate: Date.cardExpireDateToDateObject(self.expireDate) ?? Date(),
                      name: self.cardName.isEmpty ? "A card name" : self.cardName,
                      isMain: false, cardType: .visa, status: .active, moneyAmount: 800)
            )
            
            self.hideLoader()
            
            self.showCustomAlert(alert: .init(displayMode: .banner(.pop), type: .regular, title: "add_card_success".localize))
            completion()
        }
    }
    
    deinit {
        Logging.l("Deinit add new card view model")
    }
}
