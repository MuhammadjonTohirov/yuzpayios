//
//  YTextField.swift
//  YuzPay
//
//  Created by applebro on 08/12/22.
//

import Foundation
import SwiftUI

struct YTextField: View, TextFieldProtocol {
    @Binding<String> var text: String
    
    private var placeholder: String = ""
    private var isSecure: Bool = false
    @State private var passwordVisible: Bool = false
    
    var keyboardType: UIKeyboardType = .default

    var height: CGFloat = 56
    
    var haveTitle: Bool = false
    
    private var font: Font = {
        return .mont(.medium, size: 14)
    }()
    
    private var contentType: UITextContentType = .name
    private var autoCapitalization: TextInputAutocapitalization = .sentences
    
    private var onEditing: (Bool) -> Void
    private var onCommit: () -> Void
    
    private var format: String?
    
    @State private var hintOpacity: Double = 0
    @State private var zStackAlignment: Alignment = .leading
    @State private var hintFontSize: CGFloat = 13
    @State private var hintColor: Color = Color("dark_gray")
    private var placeholderAlignment: Alignment = .leading
    private var topupHintColor: Color = Color("dark_gray")
    private var placeholderColor: Color = Color("dark_gray")
    private(set) var left: () -> any View
    private(set) var right: () -> any View
    
    init(
        text: Binding<String>,
        placeholder: String,
        isSecure: Bool = false,
        contentType: UITextContentType = .nickname,
        autoCapitalization: TextInputAutocapitalization = .sentences,
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
        
        self.isSecure = isSecure
        self.contentType = contentType
        self.autoCapitalization = autoCapitalization
        self.onEditing = onEditingChanged ?? {_ in}
        self.onCommit = onCommit ?? {}
        
        self.passwordVisible = isSecure
    }
    
    var body: some View {
        HStack(spacing: 0) {
            AnyView(left())
            
            ZStack(alignment: zStackAlignment) {
                Text(placeholder)
                    .padding(.top, 4)
                    .font(.mont(.medium, size: hintFontSize))
                    .foregroundColor(hintColor)
                    .opacity(hintOpacity)

                textField
                    .placeholder(placeholder, when: text.isEmpty, alignment: placeholderAlignment, color: Color("dark_gray"))
                    .keyboardType(keyboardType)
                    .textContentType(contentType)
                    .frame(height: height)
                    .textInputAutocapitalization(autoCapitalization)
                    .font(font)
                    .onChange(of: text) { newValue in
                        if let _format = format {
                            _text.wrappedValue = newValue.onlyNumberFormat(with: _format)
                        }
                        self.rearrangeHint()
                        self.onEditing(true)
                    }
            }

            rightView
        }
        .onAppear {
            rearrangeHint()
        }
    }
    
    @ViewBuilder var rightView: some View {
        if right() is EmptyView && isSecure {
            Button(action: {
                self.passwordVisible.toggle()
            }, label: {
                Image(passwordVisible ? "icon_open_eye" : "icon_close_eye")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16)
                    .padding(Padding.medium)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(Color("gray"))
                    }
                    .padding(Padding.small / 2)
            })
        }
        else {
            AnyView(right())
        }
    }
    
    @ViewBuilder var textField: some View {
        if !passwordVisible && isSecure {
            SecureField("", text: $text, onCommit: onCommit)
        } else {
            TextField("", text: $text, onEditingChanged: onEditing, onCommit: onCommit)
        }
    }
    
    private func rearrangeHint() {
        if !haveTitle {
            return
        }
        
        withAnimation(.easeIn(duration: 0.2)) {
            if !text.isEmpty {
                zStackAlignment = .topLeading
                hintFontSize = 12
                hintColor = topupHintColor
                hintOpacity = 1
            } else {
                zStackAlignment = .leading
                hintFontSize = 16
                hintColor = placeholderColor
                hintOpacity = 0
            }
        }
    }
}

extension YTextField {
    func set(hintColor: Color) -> YTextField {
        var view = self
        view.topupHintColor = hintColor
        return view
    }
    
    func set(font: Font) -> YTextField {
        var view = self
        view.font = font
        return view
    }
    
    func set(format: String) -> YTextField {
        var view = self
        view.format = format
        return view
    }
    
    func set(placeholderAlignment align: Alignment) -> YTextField {
        var view = self
        view.placeholderAlignment = align
        return view
    }
}

struct YTextField_Preview: PreviewProvider {
    static var previews: some View {
        @State var text: String = "1123"
        
        return VStack {
            YTextField(text: $text, placeholder: "placeholder", isSecure: false)
        }
    }
}

