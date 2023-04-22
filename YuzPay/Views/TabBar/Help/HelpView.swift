//
//  HelpView.swift
//  YuzPay
//
//  Created by applebro on 17/01/23.
//

import SwiftUI

struct HelpItem: Identifiable {
    let id: String = UUID().uuidString
    let title: String
    let detail: String
    let date: Date
}

struct HelpView: View {
    @EnvironmentObject var viewModel: TabViewModel
    
    @State var showDetails: Bool = false
    @State var items: [HelpItem] = []
    @State var selectedItem: HelpItem?
    
    var body: some View {
        ZStack {
            NavigationLink("", isActive: $showDetails) {
                if let item = selectedItem {
                    FAQDetailsView(item: item)
                }
            }
            VStack {
                Text("help".localize)
                    .mont(.semibold, size: 16)
                    .padding()
                List {
                    ForEach(items) { item in
                        Button {
                            selectedItem = item
                            showDetails = true
                        } label: {
                            rowItem(item)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("google")
        .onAppear {
            if items.isEmpty {
                for i in 0..<3 {
                    items.append(
                        .init(
                            title: "\(i) How to change language",
                            detail: "First you need to go, first you need to go first you need to go first you need to go first you need to go first you need to go first you need to go first you need to go. First you need to go, first you need to go first you need to go first you need to go first you need to go first you need to go first you need to go first you need to go. First you need to go, first you need to go first you need to go first you need to go first you need to go first you need to go first you need to go first you need to go",
                            date: Date()
                        )
                    )
                }
            }
        }
    }
    
    func rowItem(_ item: HelpItem) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(item.title)
                    .mont(.regular, size: 14)
                Text(item.detail)
                    .mont(.regular, size: 14)
                    .foregroundColor(.secondaryLabel)
                    .height(40)
                    .lineLimit(2)
                    
                Text(item.date.toExtendedString(format: "dd.mm.YYYY"))
                    .mont(.regular, size: 12)
                    .foregroundColor(.secondaryLabel)
            }
            
            RightChevron()
                .padding()
        }
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HelpView()
                .environmentObject(TabViewModel(dataService: TabDataService()))
        }
    }
}
