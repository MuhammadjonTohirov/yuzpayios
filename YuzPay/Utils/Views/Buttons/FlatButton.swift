//
//  FlatButton.swift
//  YuzPay
//
//  Created by applebro on 08/12/22.
//

import Foundation
import SwiftUI

struct FlatButton: View {
    var title: String
    
    var width: CGFloat = 200.f.sh(limit: 1.2)
    var height: CGFloat = 56.f.sh(limit: 0.8)
    var borderColor: Color = Color("accent")
    var titleColor: Color = Color("accent")
    var isEnabled: Bool = true
    var onClick: () -> Void
    
    var body: some View {
        Button {
            onClick()
        } label: {
            VStack {
                Text(title)
                    .font(.mont(.medium, size: 16))
                    .foregroundColor(titleColor)
            }
            .frame(height: height)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(style: StrokeStyle(lineWidth: 1))
                    .foregroundColor(borderColor)
            )

        }.disabled(!isEnabled)
    }
}

struct FlatButton_Preview: PreviewProvider {
    static var previews: some View {
        FlatButton(title: "Регистрация") {
            
        }
    }
}

