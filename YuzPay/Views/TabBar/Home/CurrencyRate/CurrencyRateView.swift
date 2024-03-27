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
    typealias ShowMoreAction = () -> Void

    var showMore: ShowMoreAction
    
    var showAll: Bool = false

    @State var currencyValue: String = ""
    @ObservedResults(DExchangeRate.self, configuration: Realm.config) var rates;
    
    var visibleRates: Slice<Results<DExchangeRate>> {
        rates[0..<rates.count.limitTop(showAll ? rates.count : 5)]
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 8.f.sw()) {
                Image(systemName: "arrow.left.arrow.right")
                    .resizable()
                    .fontWeight(.light)
                    .frame(width: 16, height: 16)
                Text("exchange_rates".localize)
                    .font(.mont(.semibold, size: 16))
            }
            .padding(.bottom, 10)
            .opacity(rates.isEmpty ? 0 : 1)
            
            VStack(alignment: .center) {
                ForEach(visibleRates) { rate in
                    VStack {
                        listItem(title: rate.name, value: rate.detail, date: rate.lastRefreshed?.formatted(date: .numeric, time: .shortened) ?? "")
                        
                        if visibleRates.last?.id != rate.id {
                            Divider()
                        }
                    }
                }
                
                if visibleRates.count < rates.count {
                    Button {
                        showMore()
                    } label: {
                        Text("show_all_rates".localize)
                            .mont(.medium, size: 14)
                    }
                    .padding(Padding.small)
                }

            }
            .padding(.vertical, Padding.default)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(Color.secondarySystemBackground)
            )
        }
    }
    
    func listItem(title: String, value: String, date: String) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .mont(.medium, size: 14)
                
                if !date.trimmingCharacters(in: .whitespaces).isEmpty {
                    Text(date)
                        .foregroundColor(.secondaryLabel)
                        .mont(.regular, size: 12)
                }
            }
            Spacer()
            Text(value)
                .mont(.semibold, size: 14)
        }
        .padding(.horizontal, Padding.default)
        .padding(.vertical, Padding.small / 2)
    }
}

struct CurrencyRateView_Preview: PreviewProvider {
    static var previews: some View {
        CurrencyRateView {
            
        }
    }
}
