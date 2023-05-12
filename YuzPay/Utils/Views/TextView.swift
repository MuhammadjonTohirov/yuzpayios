//
//  TextView.swift
//  YuzPay
//
//  Created by applebro on 11/05/23.
//

import SwiftUI

struct TextView: View {
    
    @Binding var text: String
    
    let placeholder: String
    
    init(text: Binding<String>, placeholder: String = "") {
        self._text = text
        self.placeholder = placeholder
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                    .frame(minHeight: 40, alignment: .leading)
                    .cornerRadius(8.0)
                    .multilineTextAlignment(.leading)
                    .padding(9)
                
                Text(text.nilIfEmpty ?? placeholder)
                    .padding()
                    .foregroundColor(.placeholderText)
                    .opacity(text.nilIfEmpty == nil ? 1 : 0)
            }
        }
    }
}

public extension Binding where Value: Equatable {
    
    init(_ source: Binding<Value?>, replacingNilWith nilProxy: Value) {
        self.init(
            get: { source.wrappedValue ?? nilProxy },
            set: { newValue in
                if newValue == nilProxy {
                    source.wrappedValue = nil
                } else {
                    source.wrappedValue = newValue
                }
            }
        )
    }
}
