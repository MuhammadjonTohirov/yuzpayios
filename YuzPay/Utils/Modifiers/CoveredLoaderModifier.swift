//
//  CoveredLoaderModifier.swift
//  YuzPay
//
//  Created by applebro on 23/02/23.
//

import Foundation
import SwiftUI

struct CoveredLoaderModifier: ViewModifier {
    @Binding var isLoading: Bool
    var message: String = "loading".localize
    func body(content: Content) -> some View {
        ZStack {
            content
            if isLoading {
                Rectangle()
                    .foregroundColor(.systemBackground.opacity(0.9))
                    .ignoresSafeArea()
                    .overlay {
                        VStack(spacing: 16) {
                            ProgressView()
                            Text(message.capitalized)
                                .mont(.regular, size: 13)
                        }
                    }
                    .transition(.opacity.animation(.easeIn(duration: 0.3)))
            }
        }
    }
}

extension View {
    func loadable(_ loading: Binding<Bool>, message: String = "loading".localize) -> some View {
        self.modifier(CoveredLoaderModifier(isLoading: loading, message: message))
    }
}
