//
//  CurrencyRateView.swift
//  YuzPay
//
//  Created by applebro on 22/12/22.
//

import Foundation
import SwiftUI
import RealmSwift
import YuzSDK

struct CurrencyRateView: View {
    @State var currencyValue: String = ""
    @ObservedResults(DExchangeRate.self, configuration: Realm.config) var rates;
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(rates) { rate in
                VStack {
                    listItem(title: rate.name, value: rate.sellingRate.asCurrency(), date: rate.lastRefreshed?.formatted(date: .numeric, time: .shortened) ?? "")
                    
                    if rates.last?.id != rate.id {
                        Divider()
                    }
                }
            }
        }
        .padding(.vertical, Padding.default)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(Color.secondarySystemBackground)
        )
    }
    
    func listItem(title: String, value: String, date: String) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .mont(.regular, size: 14)
                
                Text(date)
                    .foregroundColor(.secondaryLabel)
                    .mont(.regular, size: 12)
            }
            Spacer()
            Text(value)
                .mont(.medium, size: 14)
        }
        .padding(.horizontal, Padding.default)
    }
}

struct CurrencyRateView_Preview: PreviewProvider {
    static var previews: some View {
        CurrencyRateView()
    }
}

