//
//  AddNewCardViewModel.swift
//  YuzPay
//
//  Created by applebro on 26/12/22.
//

import Foundation
import YuzSDK

final class AddNewCardViewModel: NSObject, ObservableObject, Loadable, Alertable {
    @Published var isLoading: Bool = false
    
    @Published var alert: AlertToast = .init(displayMode: .alert, type: .loading)
    
    @Published var shouldShowAlert: Bool = false
    
    @Published var cardNumber: String = ""
    @Published var expireDate: String = ""
    @Published var cardName: String = ""
    @Published var scanCard = false
    @Published var isActive = false
    @Published var dismissView = false
    
    var currentCardType: CreditCardType?
    
    private(set) var addCardResponse: NetResAddCard?
    
    @Published var confirmAddCard: Bool = false
    
    lazy var otpViewModel: OtpViewModel = {
        return .init(title: "confirm_card".localize,
                     number: UserSettings.shared.userPhone ?? "",
                     countryCode: "+998")
    }()
    
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
    
    func detectCardType() {
        currentCardType = .detectCardType(cardNumber: cardNumber.prefix(4).asString)
    }
    
    func addNewCard() {
        setupOTPViewModel()
        
        let cardNumber = self.cardNumber.replacingOccurrences(of: " ", with: "")
        let cardName = self.cardName
        let expireDate = self.expireDate
        
        guard let cardType = self.currentCardType?.code else {
            showAlert(message: "unknown_card".localize)
            return
        }
        
        self.showLoader()
        
        Task {
            let result = await MainNetworkService.shared.addCard(card: .init(cardNumber: cardNumber, cardName: cardName, expirationDate: expireDate, type: cardType))
                        
            await MainActor.run(body: {
                self.hideLoader()

                if let data = result.success {
                    self.addCardResponse = data
                    showOTP()
                } else {
                    onFailAddCard(result.error)
                }
            })
        }
    }
    
    private func showOTP() {
        confirmAddCard = true
    }
    
    private func setupOTPViewModel() {
        otpViewModel.delegate = self
        
        otpViewModel.confirmOTP = { [weak self] otp in
            guard let self else {
                return (false, nil)
            }
            
            guard let res = self.addCardResponse else {
                return (false, nil)
            }
            
            let (card, error) = await MainNetworkService.shared.confirmCard(cardId: res.cardId, card: .init(token: res.token, code: otp))
            
            if card != nil {
                MainNetworkService.shared.syncCardList()
                return (true, nil)
            }
            
            return (false, error)
        }
        
        otpViewModel.resetOTP = { [weak self] in
            self?.confirmAddCard = false
        }
    }
    
    private func onSuccessAddCard() {
        MainNetworkService.shared.syncCardList()
        self.showCustomAlert(alert: .init(displayMode: .banner(.pop), type: .regular, title: "add_card_success".localize))
    }
    
    private func onFailAddCard(_ error: String?) {
        self.showCustomAlert(alert: .init(displayMode: .banner(.pop), type: .error(.systemRed), title: error ?? "add_card_failure".localize))
    }
    
    deinit {
        Logging.l("Deinit add new card view model")
    }
}

extension AddNewCardViewModel: OtpModelDelegate {
    func otp(model: OtpViewModel, isSuccess: Bool) {
        if isSuccess {
            confirmAddCard = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                self.dismissView = true
            }
        }
    }
}
