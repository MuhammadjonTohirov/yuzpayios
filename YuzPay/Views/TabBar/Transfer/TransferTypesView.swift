//
//  TransferTypesView.swift
//  YuzPay
//
//  Created by applebro on 19/01/23.
//

import SwiftUI

struct TransferTypesView: View {
    @StateObject var viewModel: TransferViewModel = TransferViewModel()
    @EnvironmentObject var homeViewModel: TabViewModel
    
    var body: some View {
        innerBody.onAppear {

        }
    }
    
    var innerBody: some View {
        ZStack {
            Text("\(homeViewModel.update.toExtendedString())")
                .opacity(0)
            
            VStack {
                Text("transfer".localize)
                    .mont(.semibold, size: 16)
                    .padding()
                
                TransferType.transferToOther.rowButton {                    
                    viewModel.route = .transferToOther
                }
                
                TransferType.transferToMe.rowButton {
                    viewModel.route = .transferToMe
                }
                
                TransferType.exchange.rowButton {
//                    viewModel.route = .exchange
                    viewModel.showAlert(message: "coming.soon".localize)
                }
                
                TransferType.transferInternational.rowButton {
//                    viewModel.route = .transferInternational
                    viewModel.showAlert(message: "coming.soon".localize)
                }
                
                Spacer()
            }
            .padding(.horizontal, Padding.default)
        }
        .toast($viewModel.shouldShowAlert, viewModel.alert, duration: 1.5)
        .navigationDestination(isPresented: $viewModel.showPage) {
            self.viewModel.route?.screen
                .environmentObject(self.viewModel)
        }
    }
}

struct TransferTypesView_Previews: PreviewProvider {
    static var previews: some View {
        TransferTypesView()
            .environmentObject(TabViewModel(dataService: TabDataService()))
    }
}
