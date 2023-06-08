//
//  SpringLoaderView.swift
//  YuzPay
//
//  Created by applebro on 17/02/23.
//

import SwiftUI

struct SpringLoaderView: View {
    @State private var rotation = 0.0
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.5)
            .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
            .foregroundColor(.blue)
            .rotationEffect(.degrees(rotation))
            .animation(Animation.spring(response: 0.5, dampingFraction: 0.4, blendDuration: 0.1).repeatForever(autoreverses: true), value: rotation)
            .onAppear {
                rotation = 360
            }
    }
}

struct SpringLoaderView_Previews: PreviewProvider {
    static var previews: some View {
        SpringLoaderView()
    }
}
