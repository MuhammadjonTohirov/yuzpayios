//
//  CoveredLoaderModifier.swift
//  YuzPay
//
//  Created by applebro on 23/02/23.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

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
                        VStack(spacing: 0) {
                            AnimatedImage(name: "app_loader.gif")
                                .resizable()
                                .frame(.init(w: 80, h: 80))
                            Text(message.capitalized)
                                .mont(.regular, size: 13)
                                .padding(.top, -12)
                        }
                    }
                    .transition(.opacity.animation(.easeIn(duration: 0.3)))
            }
        }
    }
}

struct ProgressLoaderModifier: ViewModifier {
    @Binding var isLoading: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isLoading {
                Rectangle()
                    .foregroundColor(.systemBackground.opacity(0.9))
                    .ignoresSafeArea()
                    .overlay {
                        VStack(spacing: 0) {
                            ProgressView()
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
    
    func progress(_ loading: Binding<Bool>) -> some View {
        self.modifier(ProgressLoaderModifier(isLoading: loading))
    }
}
