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
    
    @ObservedObject var viewModel: ItemsViewModel = ItemsViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink("", isActive: $viewModel.show, destination: {
                    viewModel.route?.screen
                })
                .zIndex(0)
                TabView {
                    Button("Show destination1") {
                        viewModel.route = .dest1
                    }
                    .tabItem {
                        Text("GO")
                    }
                }
                .zIndex(2)
            }
        }
    }
}

enum TestRoute: ScreenRoute {
    var id: String {
        switch self {
        case .dest1:
            return "dest1"
        }
    }
    
    case dest1
    
    var screen: some View {
        switch self {
        case .dest1:
            return Destination1()
        }
    }
}

class ItemsViewModel: ObservableObject {
    @Published var show: Bool = false
    @Published var route: TestRoute? {
        didSet {
            show = route != nil
        }
    }
}


struct TestView_Preview: PreviewProvider {
    static var previews: some View {
        TestView(viewModel: ItemsViewModel())
    }
}
