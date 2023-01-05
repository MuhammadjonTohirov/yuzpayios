//
//  CardLargeView.swift
//  YuzPay
//
//  Created by applebro on 01/01/23.
//

import SwiftUI

struct CardLargeView: View {
    var bankName: String
    var cardName: String
    var deposit: String
    var currency: String
    var cardType: CreditCardType
    var ownerName: String
    var cardNumber: String
    var expireDate: String
    var isMain: Bool

    @ViewBuilder
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .foregroundColor(Color("accent"))
            .frame(height: 240.f.sh(limit: 0.2))
            .overlay({
                VStack(alignment: .leading) {
                    HStack {
                        cardType.whiteIcon
                        
                        Text(bankName)
                            .textCase(.uppercase)
                            .font(.mont(.semibold, size: 16))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        if isMain {
                            Image("icon_main_card")
                                .resizable(true)
                                .frame(width: 30, height: 30)
                                .transition(.scale)
                        }
                    }.frame(height: 32)
                    
                    Text(cardName)
                        .font(.mont(.regular, size: 14))
                    HStack(alignment: .bottom) {
                        Text(deposit)
                            .font(.mont(.semibold, size: 24))
                        Text(currency)
                            .font(.mont(.semibold, size: 12))
                    }
                    
                    Spacer()
                    
                    Text(ownerName)
                        .font(.mont(.regular, size: 14))
                        .textCase(.uppercase)
                        .padding(.bottom, Padding.small)
                    
                    HStack(spacing: Padding.default) {
                        Text(cardNumber)
                        
                        Text(expireDate)
                    }
                    .font(.mont(.regular, size: 12))
                }
                .foregroundColor(.white)
                .padding(Padding.default)
                
            })
    }
}
