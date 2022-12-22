//
//  CurrencyRateView.swift
//  YuzPay
//
//  Created by applebro on 22/12/22.
//

import Foundation
import SwiftUI

struct CurrencyRateView: View {
    @State var currencyValue: String = ""
    var body: some View {
        VStack(alignment: .leading) {
            Text("1 USD = ")
                .font(.mont(.semibold, size: 16))
                .padding(.horizontal, Padding.default)
                .padding(.bottom, Padding.default)

            listItem(title: "UZS", value: "11 325,74")
            listItem(title: "EUR", value: "0.91")
            listItem(title: "RUB", value: "104.8")
            
            Text("Введите значение:")
                .font(.mont(.regular, size: 16))
                .padding(.horizontal, Padding.default)
                .padding(.top, Padding.medium)
                .foregroundColor(.secondaryLabel)
            
            HStack {
                YTextField(text: $currencyValue, placeholder: "1.00")
                    .keyboardType(.decimalPad)
                Rectangle()
                    .frame(width: 1, height: 20)
                    .foregroundColor(Color.secondaryLabel)
                    .padding(.trailing, Padding.medium)
                Text("USD")
                Image(systemName: "chevron.down")
                    .resizable()
                    .sizeToFit(width: 12)
            }
            .padding(.horizontal, Padding.default)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.tertiarySystemBackground)
            )
            .padding(.horizontal, Padding.default)
        }
        .padding(.vertical, Padding.default)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(Color.secondarySystemBackground)
        )
    }
    
    func listItem(title: String, value: String) -> some View {
        VStack {
            HStack {
                Text(title)
                Spacer()
                Text(value)
            }
            .font(.mont(.regular, size: 16))
            .padding(.horizontal, Padding.default)
            Divider()
        }
    }
}

struct CurrencyRateView_Preview: PreviewProvider {
    static var previews: some View {
        CurrencyRateView()
    }
}

