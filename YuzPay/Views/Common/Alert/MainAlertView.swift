//
//  MainAlertView.swift
//  YuzPay
//
//  Created by applebro on 28/04/23.
//

import Foundation
import SwiftUI

struct MainAlertView: View {
    @ObservedObject var viewModel: MainAlertModel
    
    var body: some View {
        innerBody
            .transition(
                .asymmetric(insertion: .opacity, removal: .opacity)
                    .animation(
                    .easeIn(duration: 0.2))
            )
    }
    
    @ViewBuilder
    var innerBody: some View {
        VStack(alignment: .center, spacing: 0) {
            Text(viewModel.title)
                .font(.headline)
                .transaction { tr in
                    tr.animation = nil
                }
            Text(viewModel.message)
                .font(.subheadline)
                .transaction { tr in
                    tr.animation = nil
                }
                .padding(Padding.small)
                .multilineTextAlignment(.center)
            Divider()
            
            ForEach(viewModel.buttons, id: \.title) { b in
                b.body
            }
        }
        .padding(.vertical, 8)
        .background {
            RoundedRectangle(cornerRadius: Padding.medium)
                .foregroundColor(.secondarySystemGroupedBackground)
                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 4)
        }
        .opacity(viewModel.alert ? 1 : 0)
        .padding(.horizontal, Padding.large)
        .frame(maxHeight: .infinity)
        .background {
            Rectangle()
                .foregroundColor(.black.opacity(0.2))
                .ignoresSafeArea()
                .opacity(viewModel.alert ? 1 : 0)
        }
    }
}

struct MainAlertViewPreviewer: PreviewProvider {
    static var vm: MainAlertModel = .init(
        alert: true,
        title: "Title",
        message: "Message,Message,Message,Message,Message,Message"
    )
    
    static var previews: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.systemBlue)
                .ignoresSafeArea()
                .overlay {
                    VStack {
                        Button("Click") {
                            vm.show(title: "GOOGLE", message: "HELLO")
                        }
                        Spacer()
                    }
                }
            
            MainAlertView(viewModel: vm)
        }
        .onAppear {
            vm.addButton(.init(title: "Yes", type: .normal, action: {
                vm.alert = false
            }))
        }
    }
}
