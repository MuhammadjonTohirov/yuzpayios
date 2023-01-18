//
//  BottomSheetView.swift
//  YuzPay
//
//  Created by applebro on 17/01/23.
//

import Foundation
import SwiftUI

struct BottomSheetView<Content: View>: View {
    @Binding var isOpen: Bool

    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content

    init(isOpen: Binding<Bool>, maxHeight: CGFloat, @ViewBuilder content: () -> Content) {
        self.minHeight = maxHeight * 0
        self.maxHeight = maxHeight
        self.content = content()
        self._isOpen = isOpen
    }
    
    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }

    private var indicator: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(Color.separator)
            .frame(
                width: 60,
                height: 6
        )
    }

    @GestureState private var translation: CGFloat = 0
    var backgroundViewOpacity: CGFloat {
        (maxHeight - abs(translation)) / maxHeight
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black.opacity(0.2))
                .opacity(isOpen ? backgroundViewOpacity : 0)
                .ignoresSafeArea()
                .allowsHitTesting(isOpen)

            GeometryReader { geometry in
                VStack(spacing: 0) {
                    self.indicator.padding()
                    self.content
                }
                .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .frame(height: geometry.size.height, alignment: .bottom)
                .offset(y: max(self.offset + self.translation, 0))
                .animation(.interactiveSpring(), value: isOpen)
                .animation(.interactiveSpring(), value: translation)
                .gesture(
                    DragGesture().updating(self.$translation) { value, state, _ in
                        state = value.translation.height
                    }.onEnded { value in
                        let snapDistance = self.maxHeight * 0.5
                        guard abs(value.translation.height) > snapDistance else {
                            return
                        }
                        self.isOpen = value.translation.height < 0
                    }
                )
            }
        }
    }
}

struct BottomSheetView_Preview: PreviewProvider {
    @State static var isOpen = true
    static var previews: some View {
        return ZStack {
            Rectangle()
                .foregroundColor(.systemRed)
                .ignoresSafeArea()
            BottomSheetView(isOpen: $isOpen, maxHeight: 400) {
                Text("GOOGLE")
            }
            .ignoresSafeArea()
        }
    }
}
