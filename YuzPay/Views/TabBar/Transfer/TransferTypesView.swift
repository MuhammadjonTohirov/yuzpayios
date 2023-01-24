//
//  TransferTypesView.swift
//  YuzPay
//
//  Created by applebro on 19/01/23.
//

import SwiftUI

struct TransferTypesView: View {
    @ObservedObject var viewModel: TransferViewModel = TransferViewModel()
    
    var body: some View {
        ZStack {
            NavigationLink("", isActive: $viewModel.showPage) {
                self.viewModel.route?.screen
                    .environmentObject(self.viewModel)
            }
            
            VStack {
                Text("transfer".localize)
                    .font(.system(size: 16), weight: .semibold)
                    .padding()
                
                TransferType.transferToOther.rowButton {
                    viewModel.route = .transferToOther
                }
                
                TransferType.transferToMe.rowButton {
                    viewModel.route = .transferToMe
                }
                
                TransferType.exchange.rowButton {
                    viewModel.route = .exchange
                }
                
                TransferType.transferInternational.rowButton {
                    viewModel.route = .transferInternational
                }
                
                Spacer()
            }
            .padding(.horizontal, Padding.default)
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

struct TransferTypesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TransferTypesView()
        }
    }
}
