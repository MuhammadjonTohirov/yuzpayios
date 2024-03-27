//
//  YFormattedField.swift
//  YuzPay
//
//  Created by applebro on 22/12/22.
//

import Foundation
import SwiftUI

struct YFormattedField: View, TextFieldProtocol {
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
        format: String,
        left: (() -> any View)? = nil,
        right: (() -> any View)? = nil,
        onEditingChanged: ((Bool) -> Void)? = nil,
        onCommit: (() -> Void)? = nil
    ) {
        
        self._text = text
        
        self.placeholder = placeholder
        
        self.format = format
        
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
            text = text.onlyNumberFormat(with: format)
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
            _text.wrappedValue = newValue.onlyNumberFormat(with: format)
        }
    }
}

struct YFormattedField_Preview: PreviewProvider {
    static var previews: some View {
        @State var text: String = "935852415"
        
        return VStack {
            YFormattedField(text: $text, placeholder: "placeholder", format: "XXXX XXXX XXXX XXXX")
        }
    }
}
