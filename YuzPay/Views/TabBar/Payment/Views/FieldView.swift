//
//  Field.swift
//  YuzPay
//
//  Created by applebro on 21/04/23.
//

import Foundation
import SwiftUI
import YuzSDK

extension MField {
    func body(text: Binding<String>, placeholder: String) -> some View {
        YTextField(text: text, placeholder: placeholder)
    }
}

struct FieldView: View {
    @StateObject var field: FieldItem

    private var placeholder: String {
        field.field.title?.nilIfEmpty ?? field.field.name.localize
    }
    
    var body: some View {
        fieldView
    }
    
    @ViewBuilder
    private var fieldView: some View {
        switch field.field.fieldType {
        case .phone:
            YPhoneField(text: $field.text, placeholder: placeholder, left: {
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

        case .money:
            YTextField(text: $field.text, placeholder: placeholder, filters: [
                .init(filter: { text in
                    return text.count <= field.field.fieldSize
                })
            ])
            .keyboardType(.numberPad)
            .set(format: "XXXXXXXXX")
                .padding(.horizontal, Padding.default)
                .modifier(YTextFieldBackgroundCleanStyle())
                .padding(.horizontal, Padding.default)

        default:
            YTextField(text: $field.text, placeholder: placeholder, filters: [
                .init(filter: { text in
                    return text.count <= field.field.fieldSize
                })
            ])
                .set(haveTitle: true)
                .set(formatter: .moneyFormatter())
                .keyboardDismissMode(.interactiveWithAccessory)
                .keyboardShortcut(.pageDown)
                .padding(.horizontal, Padding.default)
                .modifier(YTextFieldBackgroundCleanStyle())
                .padding(.horizontal, Padding.default)

        }
    }
}
