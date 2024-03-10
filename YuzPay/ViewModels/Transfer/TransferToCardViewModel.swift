//
//  SelectCardViewModel.swift
//  YuzPay
//
//  Created by applebro on 20/01/23.
//

import Foundation
import RealmSwift
import SwiftUI
import YuzSDK

extension TransferType: ScreenRoute {
    var screen: some View {
        return TransferToCardView(transferType: self)
    }
}

extension DCard {
    var asModel: CardModel {
        CardModel(id: id, cardNumber: cardNumber, expirationDate: expirationDate,
                  name: name, holderName: holderName, isMain: isMain, bankName: bankName,
                  icon: icon, cardType: cardType, status: status, backgroundImage: backgroundImage,
                  colorCode: colorCode, moneyAmount: moneyAmount)
    }
}

final class TransferViewModel: NSObject, ObservableObject, Alertable {
    @Published var showPage: Bool = false
    @Published var shouldShowAlert: Bool = false
    var alert: AlertToast = .init(type: .regular)
    
    @Published var route: TransferType? {
        didSet {
            showPage = route != nil
        }
    }
}

final class TransferToCardViewModel: NSObject, ObservableObject, Alertable, Loadable {
    var alert: AlertToast = .init(type: .complete(.label))
    
    @Published var shouldShowAlert: Bool = false
    
    @Published var showPaymentView: Bool = false
    
    @Published var receiptRows: [ReceiptRowItem] = []
    
    @Published var cards: Results<DCard>?
    
    var cardsToken: NotificationToken?
    
    @Published var searchingCard: Bool = false
    
    @Published var isLoading: Bool = false
    
    @Published var price: String = ""

    @Published var reciverNumber: String = ""
    
    @Published var cardInfo: CardModel? {
        didSet {
            if transferType == .transferToMe && (cardInfo?.cardNumber.contains("*") ?? false) && cardInfo?.cardNumber.nilIfEmpty == nil {
                getFromCardDetails()
            }
            Logging.l("From card \(cardInfo?.id ?? "-2")")
        }
    }
    
    var transactionId: Int = -1
    
    @Published var note: String = ""
    
    private var transferType: TransferType = .transferToOther
    
    private var exchangeType: ExchangeType = .buy

    var isValidForm: Bool {
        false
    }
    
    private var calculatedPayment: Float {
        let price = Float(price) ?? 0
        
        switch transferType {
        case .transferToOther, .transferToMe, .transferInternational:
            let totalPrice = price * (1 + paymentIntereset)
            return totalPrice
        case .exchange:
            guard let usd = DataBase.usdRate else {
                return 0
            }
            return price * (exchangeType == .sell ? usd.buyingRate : usd.sellingRate)
        }
    }
    
    private var paymentIntereset: Float {
        switch transferType {
        case .transferToOther, .transferToMe:
            switch cardInfo?.cardType {
            case .humo:
                return UserSettings.shared.p2pConfig?.p2p.humo ?? 0
            case .uzcard:
                return UserSettings.shared.p2pConfig?.p2p.uzCard ?? 0
            case .visa, .master, .unionpay, .wallet:
                return UserSettings.shared.p2pConfig?.p2p.visa ?? 0
            default:
                return 0
            }
        case .exchange:
            return UserSettings.shared.p2pConfig?.exchange ?? 0
        case .transferInternational:
            return 0
        }
    }
    
    private var requiredMinimumAmlunt: Double {
        switch transferType {
        case .transferToOther, .transferToMe:
            return 999
        case .exchange, .transferInternational:
            return 0
        }
    }
    
    var priceDetailsInfo: String {
        if calculatedPayment == 0 {
            return ""
        }
        
        switch transferType {
        case .transferToOther, .transferToMe, .transferInternational:
            return String(format: "%.3f%% = %@", 1 + paymentIntereset, calculatedPayment.asCurrency())
        case .exchange:
            return String(format: "%@ USD = %@ UZS", (Float(price) ?? 0).asCurrency(), calculatedPayment.asCurrency())
        }
    }
    
    override init() {
        super.init()
        cards = CreditCardManager.shared.cards
    }
    
    func onAppear() {
        cardsToken = cards?.observe(on: .main, { [weak self] change in
            guard let self else {
                return
            }
            
            switch change {
            case let .update(items, _, _, _):
                self.cards = items
            default:
                break
            }
        })
        
        if transferType == .transferToMe {
            cardInfo = cards?.firstLocal?.asModel
        }
        
        if transferType == .exchange {
            cardInfo = cards?.firstInternationalCard?.asModel
        }
    }
    
    func findCard(cardNumber: String) {
        searchingCard = true
        Task(priority: .medium) {
            guard let receiverName = await MainNetworkService.shared.findCard(with: cardNumber) else {
                return
            }
            
            DispatchQueue.main.async {
                self.cardInfo = .init(
                    id: cardNumber,
                    cardNumber: cardNumber,
                    expirationDate: Date(), name: receiverName, holderName: receiverName, isMain: false, cardType: .uzcard, status: .active, moneyAmount: 0
                )
                self.searchingCard = false
            }
        }
    }
    
    func clearFromCard() {
        self.cardInfo = nil
        self.reciverNumber = ""
    }
    
    func clearForm() {
        self.clearFromCard()
        self.note = ""
        self.price = ""
    }
    
    func showReceipt() {
        guard let cardInfo else {
            showCustomAlert(alert: .init(
                displayMode: .banner(.pop),
                type: .error(.systemOrange),
                title: "please_select_card".localize,
                subTitle: nil)
            )
            return
        }
        
        guard let amount = Double(price), amount > requiredMinimumAmlunt else {
            showCustomAlert(alert: .init(
                displayMode: .banner(.pop),
                type: .error(.systemOrange),
                title: "insufficient_transfer_amount".localize,
                subTitle: nil)
            )
            return
        }
        self.receiptRows = [
            .init(name: "date".localize, value: Date().toExtendedString(format: "HH:mm:ss, MM/dd/yy")),
            .init(name: "receiver_card_number".localize, value: cardInfo.cardNumber.maskAsMiniCardNumber),
        ]
        
        switch transferType {
        case .transferToOther, .transferToMe:
            self.receiptRows += [
                .init(name: "amount".localize, value: amount.asCurrency()),
                .init(name: "commission".localize, value: String(format: "%.1f%%", paymentIntereset * 100)),
                .init(name: "total_to_withdraw".localize, value: String(format: "%.2f UZS", calculatedPayment), type: .price)

            ]
        case .exchange:
            let withdraw: Float = exchangeType == .buy ? calculatedPayment : Float(amount)
            
            self.receiptRows += [
                .init(name: "usd_amount".localize, value: amount.asCurrency()),
                .init(name: "uzs_amount".localize, value: calculatedPayment.asCurrency()),
                .init(name: "commission".localize, value: String(format: "%.1f%%", paymentIntereset * 100)),
                .init(name: "total_to_withdraw".localize, value: String(format: "%@", withdraw.asCurrency()), type: .price)
            ]
        case .transferInternational:
            self.receiptRows += [
                .init(name: "usd_amount".localize, value: amount.asCurrency()),
                .init(name: "commission".localize, value: String(format: "%.1f%%", paymentIntereset * 100)),
                .init(name: "total_to_withdraw".localize, value: String(format: "%@", calculatedPayment.asCurrency()), type: .price)
            ]
        }
                
        showPaymentView = true
    }
    
    func doTransfer(with id: String, completion: @escaping (Int?) -> Void) {
        guard let cardInfo else {
            return
        }

        guard let amount = Double(price), amount > requiredMinimumAmlunt else {
            return
        }
        
        isLoading = true
        
        Task {
            let cn = cardInfo.cardNumber.replacingOccurrences(of: " ", with: "")
            
            func onResult(_ result: (Int?, String?)) {
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let transactionId = result.0 {
                        self.transactionId = transactionId
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            completion(result.0)
                        }
                    } else {
                        self.showCustomAlert(
                            alert: .init(
                                displayMode: .alert,
                                type: .error(.systemOrange),
                                title: result.1 ?? "transfer_failed".localize,
                                subTitle: nil)
                        )
                        
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            completion(result.0)
                        }
                    }
                }
            }
            
            switch transferType {
            case .transferToOther, .transferToMe:
                onResult(await MainNetworkService.shared.p2pTransfer(cardId: id, req: .init(cardNumber: cn, amount: amount, note: note)))
            case .exchange:
                onResult(await MainNetworkService.shared.exchange(cardId: id, req: .init(targetId: Int(cardInfo.id) ?? -2, amount: amount)))
            case .transferInternational:
                fatalError("Not implemented yet")
            }
        }
    }
    
    deinit {
        cardsToken?.invalidate()
    }
    
    func set(transferType: TransferType) {
        self.transferType = transferType
    }
    
    func set(exchangeType: ExchangeType) {
        self.exchangeType = exchangeType
    }
    
    
    fileprivate func getFromCardDetails() {
        guard let cardInfo else {
            return
        }
        
        Task {
            self.showLoader()
            if let card = await MainNetworkService.shared.getCard(id: cardInfo.id) {
                DispatchQueue.main.async {
                    self.cardInfo?.cardNumber = card.cardNumber ?? "*"
                }
            }
            
            self.hideLoader()
        }
    }
}

extension DCard {
    var isInternationalCard: Bool {
        self.currencyType == .usd
    }
    
    var isLocalCard: Bool {
        self.currencyType == .uzs
    }
}
