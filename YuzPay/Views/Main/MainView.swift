//
//  ContentView.swift
//  YuzPay
//
//  Created by applebro on 05/12/22.
//

import SwiftUI


struct MainView: View {
    @ObservedObject var viewModel = MainViewModel()
    @State private var isPresented = true
    
    var body: some View {
        viewModel.route.screen.environment(\.rootPresentationMode, self.$isPresented)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
