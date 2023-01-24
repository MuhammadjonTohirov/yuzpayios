//
//  ReceiptAndPayView.swift
//  YuzPay
//
//  Created by applebro on 23/01/23.
//

import SwiftUI
import RealmSwift

struct ReceiptAndPayView: View {
    typealias Action = (() -> Void)
    var rowItems: [ReceiptRowItem] = []
    var submitButtonTitle: String = "pay".localize
    var onClickSubmit: Action
    @State var text: String = ""
    @State private var selectedId = ""
    @State private var selectedIndex = 0
    @State private var cards: Results<DCard>?
    
    private var cardHeight: CGFloat = 120
    
    init(rowItems: [ReceiptRowItem],
         submitButtonTitle: String,
         onClickSubmit: @escaping Action) {
        self.rowItems = rowItems
        self.submitButtonTitle = submitButtonTitle
        self.onClickSubmit = onClickSubmit
    }
    
    var body: some View {
        innerBody
        .onAppear {
            cards = CreditCardManager.shared.cards
            selectedId = cards?.first?.id ?? ""
            selectedIndex = 0
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var innerBody: some View {
        VStack(alignment: .center) {
            ForEach(rowItems) { item in
                item.row
            }
            Spacer()
            
            cardsView
                .background(Color.secondarySystemBackground)
            
            FlatButton(title: submitButtonTitle, titleColor: .white) {
                self.onClickSubmit()
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
            } else {
                EmptyView()
            }
        }
    }
    
    func cardsView(_ cardList: Results<DCard>) -> some View {
        VStack {
            PageView(cardList.map({ element in
                card(card: element)
            }), $selectedIndex)

            .mask {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(Color.systemBackground)
                    .frame(height: cardHeight)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke()
                    .foregroundColor(.separator.opacity(0.2))
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(Color.systemBackground)
                    .frame(height: cardHeight)
            )
            .frame(height: cardHeight)
            .padding(.horizontal, Padding.default)
            PageControl(numberOfPages: cardList.count, currentPage: $selectedIndex)
                .foregroundColor(Color.accentColor)
                .padding(.bottom, Padding.small)
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
            .padding(8)
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
                        .mont(.semibold, size: 18.f.sw())
                    Text("sum")
                        .mont(.semibold, size: 14.f.sw())
                }
                
                Text("Баланс")
                    .mont(.medium, size: 12.f.sw())
                    .foregroundColor(.secondaryLabel)
            }
        }
        .padding(Padding.small)
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

struct ReceiptAndPayView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptAndPayView(rowItems: [
            .init(name: "Карта:", value: "Uzcard от Anor Bank"),
            .init(name: "Будет доставлена:", value: "через 14 дней"),
            .init(name: "Адрес доставки:", value: "Мирабадский р-н, 17, 5"),
            .init(name: "Стоимость выпуска:", value: "30 000 сум"),
            .init(name: "Стоимость доставки:", value: "10 000 сум"),
            .init(name: "Общая стоимость:", value: "40 000 сум")
        ], submitButtonTitle: "transfer".localize) {
            
        }
        .navigationTitle("transfer_to_card".localize)
    }
}
