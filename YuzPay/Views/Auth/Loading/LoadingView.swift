//
//  LoadingView.swift
//  YuzPay
//
//  Created by applebro on 19/12/22.
//

import Foundation
import SwiftUI
import SwiftUIX

struct LoadingView: View {
    var viewModel: LoadingViewModelProtocol
    
    var body: some View {
        Text("loading".localize)
            .onAppear {
                viewModel.initialize()
            }
    }
}
