//
//  MerchantPaymentView.swift
//  YuzPay
//
//  Created by applebro on 24/01/23.
//

import SwiftUI
import RealmSwift
struct MerchantPaymentView: View {
    var merchantId: String
    
    var merchant: DMerchant? {
        Realm.new?.object(ofType: DMerchant.self, forPrimaryKey: merchantId)
    }
    
    @State var amount: String = ""
    @State var phone: String = ""
    
    @State var showStatusView = false
    @State var showPaymentView = false
    
    var body: some View {
        ZStack {
            NavigationLink("", isActive: $showStatusView) {
                PaymentStatusView(title: "Success", detail: "Payment is successfull") {
                    Image("image_success_2")
                        .renderingMode(.template)
                        .resizable(true)
                        .frame(width: 100, height: 100)
                } onClickRetry: {
                    
                } onClickCancel: {
                    self.showStatusView = false
                } onClickFinish: {
                    
                }
            }
            NavigationLink("", isActive: $showPaymentView) {
                ReceiptAndPayView(rowItems: [
                    .init(name: "Receiver card number", value: "•••• 1212"),
                    .init(name: "Receiver name", value: "Master shifu"),
                    .init(name: "Date", value: "12.12.2023"),
                    .init(name: "Amount", value: "10 000 sum"),
                ], submitButtonTitle: "pay".localize) {
                    showPaymentView = false
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        self.showStatusView = true
                    }
                }
                .navigationTitle("transfer".localize)
            }
            
            if let m = merchant {
                innerBody(m)
            }
        }
    }
    
    func innerBody(_ merchant: DMerchant) -> some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.secondarySystemBackground)
                .frame(width: 100, height: 100)
                .overlay {
                    Image(merchant.icon)
                        .resizable(true)
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 80)
                }
                .padding(.top, Padding.default)
                .padding(.bottom, Padding.default)
            
            YPhoneField(text: $phone, placeholder: "login".localize, left: {
                HStack {
                    Text("+998")
                        .font(.mont(.medium, size: 16))
                        .padding(.leading)
                        .foregroundColor(Color("dark_gray"))
                    Rectangle()
                        .frame(width: 1, height: 40)
                        .foregroundColor(Color("gray_border"))
                }
                .padding(.trailing, Padding.default)
            }, onCommit: {
                
            })
            .modifier(YTextFieldBackgroundCleanStyle())
            .padding(.horizontal, Padding.default)
            
            YTextField(text: $amount, placeholder: "amount".localize)
                .keyboardType(.decimalPad)
                .padding(.horizontal, Padding.default)
                .modifier(YTextFieldBackgroundCleanStyle())
                .padding(.horizontal, Padding.default)
                .onChange(of: amount) { newValue in
                    _amount.wrappedValue = newValue.onlyNumberFormat(with: "XXXXXXXXX")
                }
            
            Spacer()
            
            HoverButton(title: "next".localize,
                        backgroundColor: Color.accentColor,
                        titleColor: .white,
                        isEnabled: true)
            {
                showPaymentView = true
            }
            .padding(.horizontal, Padding.default)
            .padding(.bottom, Padding.medium)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(merchant.title)
    }
}

struct MerchantPaymentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MerchantPaymentView(merchantId: Realm.new!.objects(DMerchant.self).first!.id)
        }
    }
}
