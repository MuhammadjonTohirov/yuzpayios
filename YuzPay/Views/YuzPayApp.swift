//
//  YuzPayApp.swift
//  YuzPay
//
//  Created by applebro on 05/12/22.
//

import SwiftUI
import RealmSwift

@main
struct YuzPayApp: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(ItemsViewModel())
                .environment(\.realmConfiguration, Realm.config)
                .onAppear {
                    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
                }
        }
    }
}

struct YuzPayApp_Preview: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel(route: .pin))
            .environment(\.realmConfiguration, Realm.config)
            .onAppear {
                print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
            }
    }
}
