//
//  YNavigationView.swift
//  YuzPay
//
//  Created by applebro on 19/12/22.
//

import Foundation
import SwiftUI

struct YNavigationView: View {
    @ViewBuilder var content: () -> any View
    
    var body: some View {
        if #available(iOS 16, *) {
            NavigationStack {
                AnyView(content())
            }
        } else {
            NavigationView {
                AnyView(content())
                    .navigationViewStyle(StackNavigationViewStyle())
            }
        }
    }
}
