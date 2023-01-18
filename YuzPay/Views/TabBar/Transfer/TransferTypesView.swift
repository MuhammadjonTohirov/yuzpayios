//
//  TransferTypesView.swift
//  YuzPay
//
//  Created by applebro on 19/01/23.
//

import SwiftUI

struct TransferTypesView: View {
    var body: some View {
        VStack {
            Text("Transfer")
                .font(.system(size: 16), weight: .semibold)
                .padding()
            RowButton(icon: Image("icon_card"), text: "transfer_to_card".localize) {
                
            } accessoryIcon: {
                AnyView(RightChevron())
            }
            RowButton(icon: Image("icon_wallet"), text: "transfer_to_wallet".localize) {
                
            } accessoryIcon: {
                AnyView(RightChevron())
            }
            RowButton(icon: Image("icon_account_card"), text: "transfer_to_account".localize) {
                
            } accessoryIcon: {
                AnyView(RightChevron())
            }
            
            Spacer()
        }
        .padding(.horizontal, Padding.default)
        
    }
}

struct TransferTypesView_Previews: PreviewProvider {
    static var previews: some View {
        TransferTypesView()
    }
}
