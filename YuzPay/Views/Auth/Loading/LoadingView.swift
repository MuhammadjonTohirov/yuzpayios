//
//  LoadingView.swift
//  YuzPay
//
//  Created by applebro on 19/12/22.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct LoadingView: View {
    var viewModel: LoadingViewModelProtocol
    
    var body: some View {
        
        VStack {
            AnimatedImage(name: "app_loader.gif")
                .resizable()
                .frame(.init(w: 80, h: 80))
                
            Text("loading".localize)
        }
            .aspectRatio(contentMode: .fit)
            .onAppear {
                viewModel.initialize()
            }
    }
}

struct LoadingView_Preview: PreviewProvider {
    static var previews: some View {
        LoadingView(viewModel: LoadingViewModel())
    }
}
