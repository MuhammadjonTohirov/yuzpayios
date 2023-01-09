//
//  YuzPayApp.swift
//  YuzPay
//
//  Created by applebro on 05/12/22.
//

import SwiftUI
import SwiftUIX
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
