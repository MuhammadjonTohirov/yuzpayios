//
//  YPhoneField.swift
//  YuzPay
//
//  Created by applebro on 10/12/22.
//

import Foundation
import SwiftUI

struct YPhoneField: View, TextFieldProtocol {
    @Binding<String> var text: String
    
    private var placeholder: String = ""
    private var format: String = "XX XXX-XX-XX"
    private var onEditingChanged: (Bool) -> Void
    private var onCommit: () -> Void
    
    private(set) var left: () -> any View
    private(set) var right: () -> any View
    
    init(
        text: Binding<String>,
        placeholder: String,
        left: (() -> any View)? = nil,
        right: (() -> any View)? = nil,
        onEditingChanged: ((Bool) -> Void)? = nil,
        onCommit: (() -> Void)? = nil
    ) {
        
        self._text = text
        
        self.placeholder = placeholder
        
        self.left = left ?? {
            EmptyView()
        }
        
        self.right = right ?? {
            EmptyView()
        }
        
        self.onEditingChanged = onEditingChanged ?? {_ in}
        self.onCommit = onCommit ?? {}
    }
    
    var body: some View {
        HStack(spacing: 0) {
            AnyView(left())
            
            textField
                .placeholder(placeholder, when: text.isEmpty)
                .keyboardType(.numberPad)
                .frame(height: 56)
                .font(.mont(.medium, size: 16))

            AnyView(right())
        }
        .onAppear {
            text = format(with: format, phone: text)
        }
    }
    
    @ViewBuilder var textField: some View {
        TextField(
            "",
            text: $text,
            
            onEditingChanged: { changed in
                onEditingChanged(changed)
                print("\(changed) \(text)")
            },
            onCommit: onCommit
        )
        .onChange(of: text) { newValue in
            _text.wrappedValue = format(with: format, phone: newValue)
        }
    }
    
    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
}

struct YPhoneField_Preview: PreviewProvider {
    static var previews: some View {
        @State var text: String = "935852415"
        
        return VStack {
            YTextField(text: $text, placeholder: "placeholder", isSecure: false)
        }
    }
}
