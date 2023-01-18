//
//  SettingsView.swift
//  YuzPay
//
//  Created by applebro on 17/01/23.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    var body: some View {
        innerBody
    }
    
    var innerBody: some View {
        VStack {
            Text("settings".localize)
                .font(.system(size: 16), weight: .semibold)
                .padding()

            RowButton(
                icon: Image("icon_language"),
                text: "language".localize,
                details: UserSettings.shared.language?.name ?? "English",
                onClick: {
                    
                }) {
                    AnyView(
                        RightChevron()
                    )
                }
            
            RowButton(
                icon: Image("icon_pin_2"),
                text: "change_pin".localize,
                onClick: {
                    
                }) {
                    AnyView(
                        RightChevron()
                    )
                }
            
            RowButton(
                icon: Image("icon_trash 1"),
                text: "delete_account".localize,
                onClick: {
                    
                })
            
            Spacer()
        }
        .padding(.horizontal, Padding.default)
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct SettingsView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
        }
    }
}
