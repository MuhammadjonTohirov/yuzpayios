//
//  TransferToCardView.swift
//  YuzPay
//
//  Created by applebro on 19/01/23.
//

import SwiftUI
import SwiftUIX

struct TransferToCardView: View {
    @State var reciverNumber: String = ""
    @State var price: String = ""
    @State var note: String = ""
    var body: some View {
        VStack {
            Text("sender_card".localize)
                .mont(.medium, size: 14)
                .horizontal(alignment: .leading)
            
            fromCardView
            
            RightChevron()
                .rotationEffect(.pi / 2)
                .padding()
            
            Text("receiver_card".localize)
                .mont(.medium, size: 14)
                .horizontal(alignment: .leading)

            reciverCardView
            
            YTextField(text: $price, placeholder: "amount".localize)
                .keyboardType(.numberPad)
                .padding(.horizontal, Padding.default)
                .modifier(YTextFieldBackgroundCleanStyle())
                .padding(.top, Padding.medium)
            Text("0.005% = ")
                .mont(.regular, size: 12)
                .foregroundColor(.secondaryLabel)
                .padding(.leading, Padding.small)
                .horizontal(alignment: .leading)
                .padding(.bottom, Padding.medium)
            
            TextView(text: $note)
                .lineLimit(7)
                .placeholder("Note", when: note.isEmpty, alignment: .topLeading)
                .frame(height: 150)
                .padding(.horizontal, Padding.default)
                .padding(.top, Padding.medium)
                .modifier(YTextFieldBackgroundCleanStyle())
            Spacer()
                
            FlatButton(title: "send".localize, borderColor: .clear, titleColor: .white) {
                
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.accentColor)
            )
            .padding(.horizontal, Padding.medium)
        }
        .padding(.horizontal, Padding.default)

    }
    
    var fromCardView: some View {
        HStack(spacing: 20) {
            BorderedCardIcon(name: "icon_uzcard")
            
            VStack {
                Text("•••• 1222")
                    .mont(.medium, size: 12)
                Text("500 000 sum")
                    .mont(.semibold, size: 14)
            }
            Spacer()
            
            RightChevron()
        }
    }
    
    var reciverCardView: some View {
        HStack(spacing: 20) {
            BorderedCardIcon(name: "icon_card")
            
            YFormattedField(text: $reciverNumber, placeholder: "card_number".localize, format: "XXXX XXXX XXXX XXXX")
            
            RoundedRectangle(cornerRadius: 8)
                .frame(width: 40, height: 40)
                .foregroundColor(.secondarySystemBackground)
                .overlay {
                    Button {} label: {
                        Image("icon_card")
                            .renderingMode(.template)
                        .foregroundColor(Color(uiColor: .appDarkGray))
                    }
                }
            
            RoundedRectangle(cornerRadius: 8)
                .frame(width: 40, height: 40)
                .foregroundColor(.secondarySystemBackground)
                .overlay {
                    Button {} label: {
                        Image("icon_camera")
                            .renderingMode(.template)
                            .foregroundColor(Color(uiColor: .appDarkGray))
                    }
                }
        }
    }
}

struct TransferToCardView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TransferToCardView()
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
