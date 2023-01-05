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

    var width: CGFloat = 200.f.sh(limit: 1.2)
    var height: CGFloat = 56.f.sh(limit: 0.8)
    var backgroundColor: Color = Color("background")
    var titleColor: Color = Color.black
    var isEnabled: Bool = true
    var onClick: () -> Void
        
    var body: some View {
        Button {
            onClick()
        } label: {
            VStack {
                titleView
                    .font(.mont(.medium, size: 16))
                    .foregroundColor(titleColor)
            }
            .frame(height: height)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(backgroundColor.opacity(isEnabled ? 1 : 0.5))
                    .shadow(color: Color("accent").opacity(0.12), radius: isEnabled ? 8 : 0, y: isEnabled ? 4 : 0)
            )
        }.disabled(!isEnabled)
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
}

struct HoverButton_Preview: PreviewProvider {
    static var previews: some View {
        HoverButton(title: "Регистрация") {
            
        }
    }
}

