//
//  SelectCardDeliveryTypeView.swift
//  YuzPay
//
//  Created by applebro on 02/01/23.
//

import Foundation
import SwiftUI

struct SelectDeliveryTypeView: View {
    @State var showBankBranchesView = false
    @State var showAddressView = false
    @EnvironmentObject var viewModel: OrderCardViewModel
    var body: some View {
        ZStack {
            NavigationLink("", isActive: $showBankBranchesView) {
                SelectBankBranchView()
                    .environmentObject(viewModel)
            }
            
            
            NavigationLink("", isActive: $showAddressView) {
                InsertDeliveryDetailsView()
                    .environmentObject(viewModel)
            }
            
            
            Text("how_to_get_card".localize)
                .mont(.semibold, size: 28)
 
            VStack {
                Spacer()
                
                FlatButton(title: "delivery".localize, borderColor: .clear, titleColor: .white) {
                    showAddressView = true
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color("accent"))
                )
                
                FlatButton(title: "pickup_from_bank".localize) {
                    showBankBranchesView = true
                }
            }
            .padding(Padding.default)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("order_card".localize)
    }
}

struct SelectDeliveryTypeView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SelectDeliveryTypeView()
        }
    }
}

