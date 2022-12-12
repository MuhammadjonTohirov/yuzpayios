//
//  ContentView.swift
//  YuzPay
//
//  Created by applebro on 05/12/22.
//

import SwiftUI

struct ContentView: View {
    @State var cardNumber: String = ""
    @State var number: String = "123"
    var body: some View {
        return AuthIntroView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
