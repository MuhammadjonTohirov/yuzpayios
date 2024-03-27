//
//  TestView.swift
//  YuzPay
//
//  Created by applebro on 22/12/22.
//

import Foundation
import SwiftUI
import RealmSwift

struct TestView: View {
        
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView(.horizontal) {
                    content
                }
                .contentTransition(.opacity)
                .maxWidth(.infinity)
            }
        }
    }
    
    var content: some View {
        LazyHStack {
            ForEach(0..<10) { _ in
                contentItem
            }
        }
    }
    
//    image, title description vertically as a card
    var contentItem: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image("logo_yuz2")
                .renderingMode(.template)
            Text("title")
                .font(.system(size: 16, weight: .semibold))

            Text("description")
                .font(.system(size: 14, weight: .regular))
        }
        .foregroundColor(.white)
        .padding(Padding.medium)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color.black)
                .shadow(color: .gray, radius: 6, x: 4, y: 2)
        )
    }
}

//previewer
struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}

