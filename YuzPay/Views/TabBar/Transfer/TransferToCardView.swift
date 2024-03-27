//
//  TransferToCardView.swift
//  YuzPay
//
//  Created by applebro on 19/01/23.
//

import SwiftUI
import YuzSDK
import Introspect
import RealmSwift

struct TransferToCardView: View {
    @StateObject private var viewModel: TransferToCardViewModel = TransferToCardViewModel()
    
    @State var transferType: TransferType
    
    @State private var exchangeType: ExchangeType = .buy
    
    @State private var cardSelectionView: Bool = false
    
    @State private var showStatusView: Bool = false
    
    @State private var showSavedCards = false
    
    @State private var showScanCard = false
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedResults(DExchangeRate.self, configuration: Realm.config) var exchangeRates;
    
    private var amountUnitValue: String {
        switch transferType {
        case .transferToOther, .transferToMe:
            return "uzs"
        case .exchange, .transferInternational:
            return "usd"
        }
    }
    
    private var requiredHeightForCardsSelectionView: CGFloat {
        return (CGFloat(viewModel.cards?.count ?? 1) * 50).limitTop(UIScreen.screen.height / 2).limitBottom(UIScreen.screen.height / 3)
    }
    private var title: String {
        showStatusView ? "" : transferType.title
    }
    
    var body: some View {
        bodyWithNavigations
            .toast($viewModel.shouldShowAlert, viewModel.alert, duration: 1)
            .loadable($viewModel.isLoading, message: "please_wait".localize)
            .onChange(of: exchangeType, perform: { type in
                self.viewModel.set(exchangeType: type)
            })
            .onAppear {
                self.viewModel.set(transferType: transferType)
            }
    }
    
    var bodyWithNavigations: some View {
        ZStack {
            innerBody
                .sheet(isPresented: $cardSelectionView, content: {
                    SelectCardView(cards: viewModel.cards?.filter({ card in
                        switch transferType {
                        case .transferToOther, .transferToMe:
                            return card.cardType == .uzcard || card.cardType == .humo
                        case .exchange:
                            if exchangeType == .sell {
                                return card.cardType == .uzcard || card.cardType == .humo
                            }
                            
                            return !(card.cardType == .uzcard || card.cardType == .humo)
                        default:
                            return true
                        }
                    }) ?? [], selectedCardId: viewModel.cardInfo?.id ?? "-1") { newSelectedCard in
                        viewModel.cardInfo = newSelectedCard.asModel
                        cardSelectionView = false
                    }
                    .presentationDetents([.height(requiredHeightForCardsSelectionView), .medium, .large])
                })
                .sheet(isPresented: $viewModel.showPaymentView, content: {
                    receiptSheet
                })
                .navigationDestination(isPresented: $showSavedCards, destination: {
                    SavedCardsListView()
                })
                .ignoresSafeArea(edges: .bottom)
        }
        .fullScreenCover(isPresented: $showScanCard) {scanCardView}
        .onAppear {
            viewModel.onAppear()
        }
        .onDisappear {
            print("On transfer page disappear")
        }
        .overlay {
            paymentSuccessView
                .opacity(showStatusView ? 1 : 0)
        }
    }
    
    private var receiptSheet: some View {
        NavigationStack {
            ReceiptAndPayView(rows: $viewModel.receiptRows)
                .set(submitButtonTitle: "pay".localize)
                .set(showCards: true)
                .set(filter: { card in
                    if card.id == viewModel.cardInfo?.id {
                        return false
                    }
                    
                    switch transferType {
                    case .transferToOther, .transferToMe:
                        return card.cardType == .uzcard || card.cardType == .humo
                    case .exchange:
                        if exchangeType == .buy {
                            return card.cardType == .uzcard || card.cardType == .humo
                        }
                        
                        return card.cardType == .visa || card.cardType == .master
                    case .transferInternational:
                        return card.cardType == .visa || card.cardType == .master
                    }
                })
                .set { cardId in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        self.viewModel.doTransfer(with: cardId) { transactionId in
                            self.showStatusView = transactionId != nil
                        }
                    }
                }
                .navigationTitle(title)
        }
    }
    
    // MARK: - Inner body
    var innerBody: some View {
        GeometryReader { proxy in
            geometryBody(proxy.frame(in: .global))
        }
    }
    
    private func geometryBody(_ size: CGRect) -> some View {
        VStack(spacing: 0) {
            VStack {
                Text("select_receiver_card".localize)
                    .mont(.medium, size: 14)
                    .horizontal(alignment: .leading)
                    .padding(.bottom, Padding.small)
                
                receiverView
                    .onChange(of: viewModel.reciverNumber) { newValue in
                        let cardNumber = newValue.replacingOccurrences(of: " ", with: "")
                        if cardNumber.count == 16 {
                            self.viewModel.findCard(cardNumber: cardNumber)
                        }
                    }
                
                YTextField(text: $viewModel.price, placeholder: "amount".localize, right: {
                    Text(amountUnitValue.uppercased())
                        .mont(.medium, size: 14)
                        .foregroundColor(.secondaryLabel)
                })
                .set(haveTitle: true)
                .keyboardType(.numberPad)
                .padding(.horizontal, Padding.default)
                .modifier(YTextFieldBackgroundCleanStyle())
                .padding(.top, Padding.medium)
                
                Text(viewModel.priceDetailsInfo)
                    .mont(.regular, size: 12)
                    .foregroundColor(.secondaryLabel)
                    .padding(.leading, Padding.small)
                    .horizontal(alignment: .leading)
                    .padding(.bottom, Padding.medium)
                
                noteView
                currencyRateView
                    .padding(.horizontal, -Padding.default)
                Spacer()
            }
            .padding(.top, Padding.large)
            .scrollable()
            
            FlatButton(
                title: "send".localize,
                borderColor: .clear, titleColor: .white) {
                    UIApplication.shared.endEditing()
                    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.2) {
                        viewModel.showReceipt()
                    }
                }
                .frame(height: 60)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(.accentColor)
                )
                .padding(.bottom, Padding.default)
        }
        .keyboardDismissMode(.onDrag)
        .padding(.horizontal, Padding.default)
        .navigationTitle(title)
        .dismissableKeyboard()
    }
    
    // MARK: - Note view
    @ViewBuilder
    private var noteView: some View {
        if transferType == TransferType.transferToOther {
            TextView(text: $viewModel.note, placeholder: "note".localize)
                .multilineTextAlignment(.leading)
                .mont(.regular, size: 14)
                .frame(height: 150)
                .lineLimit(7)
                .modifier(YTextFieldBackgroundGrayStyle())
        }
    }
    
    // MARK: - Currency rate view
    @ViewBuilder
    private var currencyRateView: some View {
        if transferType == .transferInternational || transferType == .exchange {
            ForEach(exchangeRates.filter({$0.code == "USD"})) { rate in
                ReceiptRowItem(name: rate.name, value: "\((self.exchangeType == .sell ? rate.buyingRate : rate.sellingRate).asCurrency()) uzs").row
            }
        }
    }
    
    // MARK: - My cards view
    private var myCardsView: some View {
        Button {
            cardSelectionView = true
        } label: {
            HStack(spacing: Padding.small) {
                BorderedCardIcon(name: viewModel.cardInfo?.cardType.localIcon ?? "icon_card")
                
                VStack(alignment: .leading) {
                    Text(viewModel.cardInfo?.cardNumber.maskAsCardNumber ?? "select_card".localize)
                        .mont(.medium, size: 12)
                    Text(viewModel.cardInfo == nil ? "no_card".localize : "\(viewModel.cardInfo?.moneyAmount.asCurrency() ?? "0")")
                        .mont(.semibold, size: 14)
                }
                Spacer()
                
                RightChevron()
            }
        }
    }
    
    // MARK: - Receiver card view
    private var receiverCardView: some View {
        HStack(spacing: Padding.small) {
            BorderedCardIcon(name: viewModel.cardInfo?.cardType.localIcon ?? "icon_card")
                .overlay {
                    ProgressView()
                        .visible(viewModel.searchingCard)
                }
            
            if let c = viewModel.cardInfo {
                cardInfoField(title: c.holderName.nilIfEmpty ?? c.name.nilIfEmpty ?? c.bankName ?? "", detail: "XXXX XXXX XXXX XXXX")
                    .disabled(true)
                
                Button {
                    viewModel.clearFromCard()
                } label: {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 40, height: 40)
                        .foregroundColor(.secondarySystemBackground)
                        .overlay {
                            Image("icon_x")
                        }
                }
            }
            else {
                cardInfoField(title: "card_number".localize, detail: "XXXX XXXX XXXX XXXX")
                
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 40, height: 40)
                    .foregroundColor(.secondarySystemBackground)
                    .overlay {
                        Button {
                            showScanCard = true
                        } label: {
                            Image("icon_camera")
                                .renderingMode(.template)
                                .foregroundColor(Color(uiColor: .appDarkGray))
                        }
                    }
            }
        }
    }
    // MARK: - Card Info Field
    private func cardInfoField(title: String, detail: String) -> some View {
        YTextField(text: $viewModel.reciverNumber, placeholder: title)
            .set(format: detail)
            .set(haveTitle: true)
            .keyboardType(.numberPad)
            .frame(height: 50)
    }
    
    // MARK: - Receiver View
    @ViewBuilder
    private var receiverView: some View {
        switch transferType {
        case .transferToOther, .transferInternational:
            receiverCardView
        case .transferToMe:
            myCardsView
        case .exchange:
            VStack {
                ExchangeTypeView(selectedType: $exchangeType)
                    .padding(.bottom, Padding.medium)
                    .onChange(of: exchangeType) { newExType in
                        switch newExType {
                        case .buy:
                            self.viewModel.cardInfo = self.viewModel.cards?.firstInternationalCard?.asModel
                        case .sell:
                            self.viewModel.cardInfo = self.viewModel.cards?.firstLocal?.asModel
                        }
                    }
                
                myCardsView
            }
        }
    }
    
    // MARK: - Scan Card View
    @ViewBuilder
    private var scanCardView: some View {
        CardReaderWrapper { cardNumber, expireDate in
            
        }
        .ignoresSafeArea(.all)
    }
    
    private var paymentSuccessView: some View {
        return P2PStatusView(amount: viewModel.price + " so'm", name: viewModel.cardInfo?.holderName ?? "", transferId: self.viewModel.transactionId)
    }
}

enum ExchangeType: Int {
    case buy = 0
    case sell
}

// MARK: - Exchange
struct ExchangeTypeView: View {
    @Binding var selectedType: ExchangeType
    
    var body: some View {
        HStack(spacing: Padding.medium) {
            Spacer()
            Button {
                selectedType = .buy
            } label: {
                Label("buy".localize, systemImage: "arrow.down.circle")
            }
            .padding(.horizontal, Padding.medium)
            .padding(.vertical, Padding.small)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(Color.accentColor.opacity(selectedType == .buy ? 0.1 : 0))
            )
            .foregroundColor(.accentColor)
            
            Button {
                selectedType = .sell
            } label: {
                Label("sell".localize, systemImage: "arrow.up.circle")
            }
            .padding(.horizontal, Padding.medium)
            .padding(.vertical, Padding.small)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(Color.accentColor.opacity(selectedType == .buy ? 0 : 0.1))
            )
            .foregroundColor(.accentColor)
        }
    }
}

struct TransferToCardView_Previews: PreviewProvider {
    static var previews: some View {
        TransferToCardView(transferType: .transferToMe)
            .navigationBarTitleDisplayMode(.inline)
            .environmentObject(TransferToCardViewModel())
    }
}
