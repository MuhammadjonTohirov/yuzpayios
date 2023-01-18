//
//  SelectCardTypeView.swift
//  YuzPay
//
//  Created by applebro on 02/01/23.
//

import Foundation
import SwiftUI

struct SelectCardTypeView: View {
    var cardTypeList: [CreditCardType] = [
        .uzcard, .humo, .visa, .master, .unionpay
    ]
    
    @EnvironmentObject var viewModel: OrderCardViewModel
    
    @State var showDeliveryType = false
    
    var body: some View {
        ZStack {
            NavigationLink("", isActive: $showDeliveryType) {
                SelectDeliveryTypeView()
                    .environmentObject(viewModel)
            }
            innerBody
        }
    }
    
    var innerBody: some View {
        VStack(alignment: .leading) {
            title("select_card_type".localize)
            
            ForEach(cardTypeList) { type in
                Button(action: {
                    showDeliveryType = true
                }, label: {
                    row(cardType: type)
                })
                .foregroundColor(.label)
                .padding(.horizontal, 10)
            }
            .padding(.top, Padding.default)
            
            Spacer()
        }
        .navigationTitle("order_card".localize)
    }
    
    func row(cardType type: CreditCardType) -> some View {
        HStack {
            type.icon
                .resizable(true)
                .frame(width: 32, height: 32)
                .padding(4)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.opaqueSeparator)
                        .foregroundColor(.systemBackground)
                )
            Text(type.name)
                .mont(.regular, size: 14)
            
            Spacer()
            
            RightChevron()
        }
    }

    func title(_ text: String) -> some View {
        Text(text)
            .font(.mont(.semibold, size: 28))
            .padding(.horizontal, Padding.default)
            .padding(.top, Padding.default)
    }
}
