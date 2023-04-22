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
            viewModel.onAppear()
        }
    }
    
    var innerBody: some View {
        ZStack {
            Text("\(homeViewModel.update.toExtendedString())")
                .opacity(0)

            NavigationLink("", isActive: $viewModel.showPage) {
                self.viewModel.route?.screen
                    .environmentObject(self.viewModel)
            }
            
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
                    viewModel.route = .exchange
                }
                
                TransferType.transferInternational.rowButton {
                    viewModel.route = .transferInternational
                }
                
                Spacer()
            }
            .padding(.horizontal, Padding.default)
        }
//        .fullScreenCover(isPresented: $viewModel.showPage) {
//
//        } content: {
//            NavigationView {
//                self.viewModel.route?.screen
//                    .environmentObject(self.viewModel)
//                    .navigationBarTitleDisplayMode(.inline)
//                    .toolbar(content: {
//                        ToolbarItem(placement: .navigationBarLeading) {
//                            Button {
//                                self.viewModel.route = nil
//                            } label: {
//                                Image(systemName: "xmark")
//                            }
//
//                        }
//                    })
//            }
//        }
    }
}

struct TransferTypesView_Previews: PreviewProvider {
    static var previews: some View {
        TransferTypesView()
            .environmentObject(TabViewModel(dataService: TabDataService()))
    }
}
