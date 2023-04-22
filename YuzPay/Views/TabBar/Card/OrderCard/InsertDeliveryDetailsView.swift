//
//  InsertDeliveryDetailsView.swift
//  YuzPay
//
//  Created by applebro on 02/01/23.
//

import Foundation
import SwiftUI

struct InsertDeliveryDetailsView: View {
    @EnvironmentObject var viewModel: OrderCardViewModel

    @State private var address: String = ""
    @State private var street: String = ""
    @State private var home: String = ""
    @State private var phone: String = ""
    @State private var note: String = ""
    @State var showReceipt = false
    var body: some View {
        ZStack {
            NavigationLink("", isActive: $showReceipt) {
                OrderCardReceiptView()
                    .environmentObject(viewModel)
            }
            
            innerBody
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("order_card".localize)
        }
    }
    
    var innerBody: some View {
        VStack(alignment: .leading) {
            title("Insert address")
            VStack(spacing: Padding.default) {
                YTextField(text: $address, placeholder: "Address")
                    .set(haveTitle: true)
                    .padding(.horizontal, Padding.default)
                    .modifier(YTextFieldBackgroundGrayStyle())
                    .padding(.horizontal, Padding.default)
                    .padding(.top, Padding.medium)
                
                YTextField(text: $street, placeholder: "Street")
                    .set(haveTitle: true)
                    .padding(.horizontal, Padding.default)
                    .modifier(YTextFieldBackgroundGrayStyle())
                    .padding(.horizontal, Padding.default)
                
                YTextField(text: $home, placeholder: "Home")
                    .set(haveTitle: true)
                    .padding(.horizontal, Padding.default)
                    .modifier(YTextFieldBackgroundGrayStyle())
                    .padding(.horizontal, Padding.default)
                
                YTextField(text: $phone, placeholder: "Phone")
                    .set(format: "XX XXX-XX-XX")
                    .set(haveTitle: true)
                    .padding(.horizontal, Padding.default)
                    .modifier(YTextFieldBackgroundGrayStyle())
                    .padding(.horizontal, Padding.default)
                

                TextField("Note", text: $note, axis: .vertical)
                    .lineLimit(7)
                    .frame(height: 150)
                    .padding(.horizontal, Padding.default)
                    .modifier(YTextFieldBackgroundGrayStyle())
                    .padding(.horizontal, Padding.default)
            }.scrollable()
            
            Spacer()
            
            FlatButton(title: "continue".localize) {
                showReceipt = true
            }
            .padding(.horizontal, Padding.large)
        }
    }
    
    func title(_ text: String) -> some View {
        Text(text)
            .font(.mont(.semibold, size: 28))
            .padding(.horizontal, Padding.default)
            .padding(.top, Padding.default)
    }
}

struct InsertDeliveryDetailsView_Preview: PreviewProvider {
    static var previews: some View {
        InsertDeliveryDetailsView()
            .environmentObject(OrderCardViewModel())
    }
}
