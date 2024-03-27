//
//  HoverButton.swift
//  YuzPay
//
//  Created by applebro on 08/12/22.
//

import Foundation
import SwiftUI
import UIKit

struct HoverButton: View {
    var title: String
    var leftIcon: Image?

    var height: CGFloat = 56.f.sh(limit: 0.8)
    var backgroundColor: Color = Color("background")
    var titleColor: Color = Color.black
    var isEnabled: Bool = true
    var onClick: () -> Void

    init(title: String, leftIcon: Image? = nil,
         height: CGFloat = 56.f.sh(limit: 0.8),
         backgroundColor: Color = Color("background"),
         titleColor: Color = Color.black, isEnabled: Bool = true, onClick: @escaping () -> Void) {
        self.title = title
        self.leftIcon = leftIcon
        self.height = height
        self.backgroundColor = backgroundColor
        self.titleColor = titleColor
        self.isEnabled = isEnabled
        self.onClick = onClick
    }
        
    var animated: Bool = false
        
    var body: some View {
        ZStack {
            if animated {
                ProgressView()
            } else {
                Button {
                    onClick()
                } label: {
                    VStack {
                        titleView
                            .font(.mont(.medium, size: 16))
                            .foregroundColor(titleColor)
                            .frame(maxWidth: .infinity)
                    }
                }
                .disabled(!isEnabled)
                .frame(height: height)
            }
        }
        .frame(height: height)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(!animated ? backgroundColor.opacity(isEnabled ? 1 : 0.5) : .secondarySystemBackground)
                .shadow(color: Color("accent").opacity(0.12), radius: isEnabled ? 8 : 0, y: isEnabled ? 4 : 0)
        )
    }
    
    @ViewBuilder
    private var titleView: some View {
        if let icon = self.leftIcon {
            Label {
                Text(title)
            } icon: {
                icon
            }
        } else {
            Text(title)
        }
    }
    
    func set(animated: Bool) -> Self {
        var v = self
        v.animated = animated
        return v
    }
}

struct HoverButton_Preview: PreviewProvider {
    static var previews: some View {
        HoverButton(title: "Регистрация") {
            
        }
    }
}

