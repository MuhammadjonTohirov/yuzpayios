//
//  YGridView.swift
//  YuzPay
//
//  Created by applebro on 24/01/23.
//

import Foundation
import CoreFoundation
import SwiftUI

struct YGridView: View {
    @State var isExpanded: Bool = true
    @State var numberOfItems: Int = 10
    
    private var columns: Int {
        isExpanded ? 3 : numberOfItems
    }
    
    var body: some View {
        
        VStack {
            Button {
                withAnimation {
                    isExpanded.toggle()
                }
            } label: {
                Text(isExpanded ? "Collapse" : "Expand")
            }
            
            ScrollView(isExpanded ? .vertical : .horizontal) {
                VStack(alignment: .leading) {
                    ForEach((0..<numberOfItems), id: \.self) { index in
                        HStack(spacing: 10) {
                            ForEach((index * columns)..<(index * columns) + columns, id: \.self) { i in
                                if i < self.numberOfItems {
                                    Text("Text \(i)")
                                        .frame(height: 50)
                                        .background(Color.green)
                                        .transition(.identity)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .frame(maxWidth: CGFloat.infinity)
            .aspectRatio(contentMode: ContentMode.fit)
            Text("Gamers")
            Spacer()
        }
    }
}

struct YGridView_Preview: PreviewProvider {
    static var previews: some View {
        YGridView()
    }
}
