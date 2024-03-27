//
//  VIew+Extension.swift
//  YuzPay
//
//  Created by applebro on 22/12/22.
//

import Foundation
import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

extension View {
    func toast(_ presenting: Binding<Bool>, _ alert: @autoclosure @escaping () -> AlertToast, duration: CGFloat = 0.5) -> some View {
        self.toast(isPresenting: presenting) {
            alert()
        }
        .onChange(of: presenting.wrappedValue) { newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    presenting.wrappedValue = false
                }
                
                SEffect.rigid()
            }
        }
    }
    
    func scrollable(axis: Axis.Set = .vertical, showIndicators: Bool = false) -> some View {
        self.modifier(ScrollableModifier(axis: axis, indicators: showIndicators))
    }
    
    func uscrollable(_ refreshing: Binding<Bool>) -> some View {
        UScrollView(startRefresh: refreshing) {
            self.asUIView
        }
    }
    
    func navigation<Item, Destination: View>(item: Binding<Item?>, @ViewBuilder destination: (Item) -> Destination) -> some View {
        let isActive = Binding(
            get: { item.wrappedValue != nil },
            set: { value in
                if !value {
                    item.wrappedValue = nil
                }
            }
        )
        return navigation(isActive: isActive) {
            item.wrappedValue.map(destination)
        }
    }
    
    func navigation<Destination: View>(isActive: Binding<Bool>, @ViewBuilder destination: () -> Destination) -> some View {
        overlay(
            NavigationLink(
                destination: isActive.wrappedValue ? destination() : nil,
                isActive: isActive,
                label: { EmptyView() }
            )
        )
    }
    
    func mont(_ type: UIFont.MontSerrat, size: CGFloat) -> some View {
        return self.font(.mont(type, size: size))
    }
    
    func horizontal(alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func vertical(alignment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
    
    func didAppear(action: @escaping () -> Void) -> some View {
        self.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                action()
            }
        }
    }
    
    func dismissableKeyboard() -> some View {
        self.modifier(CloseKeyboardModifier())
    }
}
