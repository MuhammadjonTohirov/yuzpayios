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
            
            
            Text("Как Вы желаете получить карту?")
                .mont(.semibold, size: 28)
 
            VStack {
                Spacer()
                
                FlatButton(title: "Доставка", borderColor: .clear, titleColor: .white) {
                    showAddressView = true
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color("accent"))
                )
                
                FlatButton(title: "Заберу в банке") {
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

