//
//  TotalAmountView.swift
//  YuzPay
//
//  Created by applebro on 04/08/23.
//

import SwiftUI
import RealmSwift
import YuzSDK

struct TotalAmountView: View {
    var cards: Results<DCard>
    
    @State private var availableCurrencies: [CurrencyType] = []
    @State private var isAmountVisible = true
    private var totalAmountString: String {
        "\(cards.filter({$0.currencyType == currentCurrencyType}).reduce(into: 0, {$0 += $1.moneyAmount}).asCurrency())"
    }
    
    private var currentCurrencyType: CurrencyType {
        availableCurrencies.item(at: currencyIndex) ?? .uzs
    }
    
    @State private var currencyIndex = 0
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("total_amount".localize)
                    .font(.mont(.medium, size: 16.f.sh()))
                
                HStack {
                    Text(isAmountVisible ? totalAmountString : "••• •••")
                        .font(.mont(.bold, size: 36.f.sh()))
                    Text(currentCurrencyType.text)
                        .font(.mont(.bold, size: 18.f.sh()))
                }
            }
            
            Spacer()

            if availableCurrencies.count > 1 {
                Button {
                    onClickChangeCardTypeFilter()
                } label: {
                    Image("icon_refresh")
                        .renderingMode(.template)
                        .foregroundColor(.label)
                        .padding(Padding.small)
                }
            }

            Button {
                isAmountVisible.toggle()
            } label: {
                Image(isAmountVisible ? "icon_open_eye" : "icon_close_eye")
                    .renderingMode(.template)
                    .foregroundColor(.label)
                    .padding(Padding.small)
            }
        }
        .onAppear {
            isAmountVisible = UserSettings.shared.isTotalBalanceVisible ?? true
            reloadAvailableCurrencies()
        }
    }
    
    private func reloadAvailableCurrencies() {
        let currencies = self.cards.sectioned(by: \.currencyType)
        self.availableCurrencies = currencies.allKeys.sorted(by: {$0.rawValue < $1.rawValue})
    }
    
    private func onClickChangeCardTypeFilter() {
        currencyIndex = (currencyIndex + 1) % availableCurrencies.count
        
        debugPrint(self.currentCurrencyType.text)
    }
}

struct TotalAmountView_Previews: PreviewProvider {
    static var previews: some View {
        let realm = Realm.new!
        realm.trySafeWrite {
            realm.add(
                DCard(
                    id: "01",
                    ownerId: "me001",
                    cardNumber: "1234123412341234",
                    expirationDate: Date(), name: "Main card",
                    holderName: "Muhammadjon", isMain: true,
                    cardType: .uzcard, status: .active, moneyAmount: 10000,
                    currency: .uzs)
                , update: .modified)
            
            realm.add(
                DCard(
                    id: "02",
                    ownerId: "me001",
                    cardNumber: "1234123412341235",
                    expirationDate: Date(), name: "Main card",
                    holderName: "Muhammadjon", isMain: false,
                    cardType: .visa, status: .active, moneyAmount: 1000,
                    currency: .usd)
                , update: .modified)
            
            realm.add(
                DCard(
                    id: "03",
                    ownerId: "me001",
                    cardNumber: "1234123412341236",
                    expirationDate: Date(), name: "Main card",
                    holderName: "Muhammadjon", isMain: false,
                    cardType: .master, status: .active, moneyAmount: 1000,
                    currency: .usd)
                , update: .modified)
            
            realm.add(
                DCard(
                    id: "04",
                    ownerId: "me001",
                    cardNumber: "1234123412341237",
                    expirationDate: Date(), name: "Main card",
                    holderName: "Muhammadjon", isMain: false,
                    cardType: .master, status: .active, moneyAmount: 100, currency: .eur)
                , update: .modified)
        }
        
        return TotalAmountView(cards: realm.objects(DCard.self))
    }
}
