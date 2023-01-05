//
//  VIew+Extension.swift
//  YuzPay
//
//  Created by applebro on 22/12/22.
//

import Foundation
import SwiftUI

extension View {
    func scrollable(axis: Axis.Set = .vertical, showIndicators: Bool = false) -> some View {
        self.modifier(ScrollableModifier(axis: axis, indicators: showIndicators))
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
}
