//
//  OrderCardReceiptView.swift
//  YuzPay
//
//  Created by applebro on 02/01/23.
//

import SwiftUI
import SwiftUIX
import RealmSwift

struct OrderCardReceiptView: View {
    @State var text: String = ""
    @State var selectedId = ""
    @State var selectedIndex = 0
    @State var cards: Results<DCard>?
    
    @State var showPaymentStatusView = false
    
    private var cardHeight: CGFloat = 120//.f.sh()
    
    @EnvironmentObject var viewModel: OrderCardViewModel
    var body: some View {
        ZStack {
            NavigationLink("", isActive: $showPaymentStatusView) {
                OrderCardPaymentStatusView(isSuccess: Bool.random())
                    .environmentObject(viewModel)
                
            }
            innerBody
        }
            .onAppear {
                cards = CreditCardManager.shared.cards
                selectedId = cards?.first?.id ?? ""
                selectedIndex = 0
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("order_card".localize)
    }
    
    var innerBody: some View {
        VStack(alignment: .center) {
            row(title: "Карта:", detais: "Uzcard от Anor Bank")
            row(title: "Будет доставлена:", detais: "через 14 дней")
            row(title: "Адрес доставки:", detais: "Мирабадский р-н, 17, 5")
            row(title: "Стоимость выпуска:", detais: "30 000 сум")
            row(title: "Стоимость доставки:", detais: "10 000 сум")
            row(title: "Общая стоимость:", detais: "40 000 сум")
            
            Spacer()
            
            cardsView
                .background(Color.secondarySystemBackground)
            
            FlatButton(title: "Заказать", titleColor: .white) {
                showPaymentStatusView = true
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color("accent"))
            )
            .padding()
        }
    }
    
    var cardsView: some View {
        VStack {
            HStack {
                Text("Оплата")
                    .mont(.semibold, size: 21.f.sh())
                Spacer()
            }
            .padding(.horizontal, Padding.default)
            .padding(.bottom, Padding.small)
            .padding(.top, Padding.medium)
            
            if let crds = self.cards {
                cardsView(crds)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke()
                            .foregroundColor(.separator.opacity(0.2))
                    }
            } else {
                EmptyView()
            }
            
            HStack {
                indicators
            }
            .padding(.top, Padding.small)
            .padding(.bottom, Padding.default)
        }
    }
    
    func cardsView(_ cardList: Results<DCard>) -> some View {
        HStack {
            PaginationView(cardList, id: \.id, showsIndicators: false, content: { element in
                card(card: element)
            })
            .currentPageIndex($selectedIndex)
        }
        .onChange(of: selectedIndex, perform: { newIndex in
            withAnimation(.easeIn(duration: 0.2)) {
                self.selectedId = cards?.item(at: newIndex)?.id ?? ""
            }
        })
        .frame(width: (UIScreen.screen.width - 40).f.sw())
        .mask {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(Color.systemBackground)
                .frame(height: cardHeight)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(Color.systemBackground)
                .frame(height: cardHeight)
        )
        .frame(height: cardHeight)
    }
    
    @ViewBuilder
    var indicators: some View {
        if let cardList = cards {
            ForEach(cardList) { card in
                Circle()
                    .stroke()
                    .foregroundColor(Color.separator)
                    .height(8)
                    .overlay {
                        Circle()
                            .foregroundColor(card.id == selectedId ? Color("accent") : .systemBackground.opacity(0.4))
                    }
            }
        } else {
            EmptyView()
        }
    }
    
    func card(card: DCard) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                card.cardType.whiteIcon
                    .shadow(color: Color.black.opacity(0.12), radius: 12)
                    .offset(x: -8)

                Spacer()

                Text(card.bankName ?? "bank_name".localize)
                    .mont(.semibold, size: 14)
                HStack(spacing: 0) {
                    Text(card.cardNumber.maskAsMiniCardNumber)
                        .mont(.regular, size: 14)
                    Spacer()
                    Text(card.expirationDate.toExtendedString(format:  "MM/YY"))
                        .mont(.regular, size: 14)
                }
            }
            .frame(width: 160.f.sw())
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color("accent"))
            )
            
            .foregroundColor(.white)
            
            
            VStack(alignment: .leading) {
                Text(card.name)
                    .mont(.semibold, size: 16.f.sw())
                Spacer()
                    .frame(maxWidth: .infinity)
                
                HStack(alignment: .bottom) {
                    Text(card.moneyAmount.asCurrency)
                        .mont(.semibold, size: 21.f.sw())
                    Text("sum")
                        .mont(.semibold, size: 14.f.sw())
                }
                
                Text("Баланс")
                    .mont(.medium, size: 14.f.sw())
                    .foregroundColor(.secondaryLabel)
            }
        }
        .padding(Padding.small)
        .frame(width: (UIScreen.screen.width - 40).sw(), height: cardHeight)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .padding(.horizontal, Padding.small)
                .foregroundColor(Color.systemBackground)
        )
    }
    
    func row(title: String, detais: String) -> some View {
        VStack {
            HStack {
                Text(title)
                Spacer()
                Text(detais)
            }
            .padding(.vertical, Padding.small.sh())
            .padding(.horizontal, Padding.default.sw())
            
            Divider()
        }
        .foregroundColor(.label.opacity(0.85))
        .mont(.regular, size: 14)
    }
}

struct OrderCardReceiptView_Previews: PreviewProvider {
    static var previews: some View {
        OrderCardReceiptView()
            .environmentObject(OrderCardViewModel())
    }
}
