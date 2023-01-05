//
//  Destination1.swift
//  YuzPay
//
//  Created by applebro on 27/12/22.
//

import SwiftUI

final class Dest1VM: ObservableObject {
    
    init() {
        Logging.l("Init dest1vm")
    }
    
    deinit {
        Logging.l("Deinit dest1vm")
    }
}

struct Destination1: View {
    @ObservedObject var vm = Dest1VM()
    
    var body: some View {
        Text("Destination 1")
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Page 2")
    }
}

struct Destination1_Previews: PreviewProvider {
    static var previews: some View {
        Destination1()
    }
}
