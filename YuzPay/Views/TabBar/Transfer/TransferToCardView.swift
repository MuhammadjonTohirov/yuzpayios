//
//  TransferToCardView.swift
//  YuzPay
//
//  Created by applebro on 19/01/23.
//

import SwiftUI
import Introspect
import SwiftUIX

struct TransferToCardView: View {
    @EnvironmentObject var viewModel: TransferViewModel
    var transferType: TransferType
    @State private var reciverNumber: String = ""
    @State private var price: String = ""
    @State private var note: String = ""
    
    @State private var cardSelectionView: Bool = false
    
    @State private var selectedCard: DCard?
    
    @State private var showPaymentView: Bool = false
    
    @State private var showStatusView: Bool = false
    
    @State private var exchangeType: ExchangeType = .buy
    
    @State private var showSavedCards = false
    
    @State private var showScanCard = false
    
    private var title: String {
        transferType.title
    }
    
    var body: some View {
        ZStack {
            NavigationLink("", isActive: $showStatusView) {
                PaymentStatusView(title: "Success", detail: "Payment is successfull") {
                    Image("image_success_2")
                        .renderingMode(.template)
                        .resizable(true)
                        .frame(width: 100, height: 100)
                } onClickRetry: {
                    
                } onClickCancel: {
                    self.showStatusView = false
                } onClickFinish: {
                    
                }
            }
            
            NavigationLink("", isActive: $showSavedCards) {
                SavedCardsListView()
            }
            
            NavigationLink("", isActive: $showPaymentView) {
                ReceiptAndPayView(rowItems: [
                    .init(name: "Receiver card number", value: "•••• 1212"),
                    .init(name: "Receiver name", value: "Master shifu"),
                    .init(name: "Date", value: "12.12.2023"),
                    .init(name: "Amount", value: "10 000 sum"),
                ], submitButtonTitle: "pay".localize) {
                    showPaymentView = false
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        self.showStatusView = true
                    }
                }
                .navigationTitle(title)
            }
            
            innerBody
            
            
            BottomSheetView(isOpen: $cardSelectionView, maxHeight: UIScreen.screen.height / 2) {
                SelectCardView(cards: viewModel.cards?.compactMap({$0}) ?? []) { newSelectedCard in
                    selectedCard = newSelectedCard
                    cardSelectionView = false
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .fullScreenCover(isPresented: $showScanCard) {scanCardView}
        .onAppear {
            selectedCard = viewModel.cards?.first
        }
        .onDisappear {
            print("On transfer page disappear")
        }
    }
    
    var innerBody: some View {
        GeometryReader { proxy in
            geometryBody(proxy.frame(in: .global))
        }
    }
    
    func geometryBody(_ size: CGRect) -> some View {
        VStack(spacing: 0) {
            VStack {
                Text("select_receiver_card".localize)
                    .mont(.medium, size: 14)
                    .horizontal(alignment: .leading)
                    .padding(.bottom, Padding.small)
                
                receiverView
                
                YTextField(text: $price, placeholder: "amount".localize)
                    .set(haveTitle: true)
                    .keyboardType(.numberPad)
                    .keyboardDismissMode(.interactive)
                    .padding(.horizontal, Padding.default)
                    .modifier(YTextFieldBackgroundCleanStyle())
                    .padding(.top, Padding.medium)
                
                Text("0.005% = ")
                    .mont(.regular, size: 12)
                    .foregroundColor(.secondaryLabel)
                    .padding(.leading, Padding.small)
                    .horizontal(alignment: .leading)
                    .padding(.bottom, Padding.medium)
                
                noteView
                currencyRateView
                Spacer()
            }
            .padding(.top, Padding.large)

            .scrollable()
                
            FlatButton(title: "send".localize, borderColor: .clear, titleColor: .white) {
                UIApplication.shared.endEditing()
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.2) {
                    showPaymentView = true
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.accentColor)
            )
            .padding(.bottom, Padding.default)
        }
        .keyboardDismissMode(.onDrag)
        .padding(.horizontal, Padding.default)
        .navigationTitle(title)
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Text("")
            }
            
            ToolbarItem(placement: .keyboard) {
                Button {
                    UIApplication.shared.endEditing()
                } label: {
                    Image(systemName: "keyboard.chevron.compact.down")
                    
                }
            }
        }
    }
    
    @ViewBuilder
    var noteView: some View {
        if transferType == TransferType.transferToOther {
            TextView(text: $note, onCommit: {
                UIApplication.shared.endEditing()
            })
                .lineLimit(7)
                .placeholder("note".localize, when: note.isEmpty, alignment: .topLeading)
                .keyboardDismissMode(.onDragWithAccessory)
                .frame(height: 100)
                .padding(.horizontal, Padding.default)
                .padding(.top, Padding.medium)
                .modifier(YTextFieldBackgroundCleanStyle())
        }
    }
    
    @ViewBuilder
    var currencyRateView: some View {
        if transferType == .transferInternational || transferType == .exchange {
            ReceiptRowItem(name: "Dollar", value: "11250 uzs").row
            ReceiptRowItem(name: "Euro", value: "13000 uzs").row
            ReceiptRowItem(name: "Ruble", value: "500 uzs").row
        }
    }
    
    var myCardsView: some View {
        Button {
            cardSelectionView = true
        } label: {
            HStack(spacing: Padding.small) {
                BorderedCardIcon(name: "icon_uzcard")
                
                VStack(alignment: .leading) {
                    Text(selectedCard?.cardNumber.maskAsMiniCardNumber ?? "****")
                        .mont(.medium, size: 12)
                    Text("\(selectedCard?.moneyAmount.asCurrency ?? "0") sum")
                        .mont(.semibold, size: 14)
                }
                Spacer()
                
                RightChevron()
            }
        }
    }
    
    var receiverCardView: some View {
        HStack(spacing: Padding.small) {
            BorderedCardIcon(name: "icon_card")
            
            YTextField(text: $reciverNumber, placeholder: "card_number".localize)
                .set(format: "XXXX XXXX XXXX XXXX")
                .set(haveTitle: true)
            
            RoundedRectangle(cornerRadius: 8)
                .frame(width: 40, height: 40)
                .foregroundColor(.secondarySystemBackground)
                .overlay {
                    Button {
                        showSavedCards = true
                    } label: {
                        Image("icon_card")
                            .renderingMode(.template)
                        .foregroundColor(Color(uiColor: .appDarkGray))
                    }
                }
            
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
    
    @ViewBuilder
    var receiverView: some View {
        switch transferType {
        case .transferToOther, .transferInternational:
            receiverCardView
        case .transferToMe:
            myCardsView
        case .exchange:
            VStack {
                ExchangeTypeView(selectedType: $exchangeType)
                .padding(.bottom, Padding.medium)
                
                myCardsView
            }
        }
    }
    
    @ViewBuilder var scanCardView: some View {
        CardReaderWrapper { cardNumber, expireDate in
            
        }
        .ignoresSafeArea(.all)
    }
}

enum ExchangeType {
    case sell
    case buy
}

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
        NavigationView(content: {
            TransferToCardView(transferType: .transferToOther)
                .navigationBarTitleDisplayMode(.inline)
                .environmentObject(TransferViewModel())
        })
    }
}
