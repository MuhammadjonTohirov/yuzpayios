//
//  TTabBar.swift
//  YuzPay
//
//  Created by applebro on 11/04/23.
//

import Foundation
import SwiftUI

struct TTabBar: View {
        
    var body: some View {
        VStack(spacing: 0) {
            s1.ignoresSafeArea()
            Image(systemName: "house")
        }
    }
    
    var s1: some View {
        Rectangle()
            .foregroundColor(.systemGreen)
    }
    
    var s2: some View {
        Rectangle()
            .foregroundColor(.systemYellow)
    }
}

struct TabBar_Preview: PreviewProvider {
    static var previews: some View {
        TTabBar()
    }
}


