//
//  TestView.swift
//  YuzPay
//
//  Created by applebro on 22/12/22.
//

import Foundation
import SwiftUI
import RealmSwift

class TestItem: Object, Identifiable {
    init(id: ObjectId, name: String) {
        self.name = name
        super.init()
        self.id = id
    }
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    
    override init() {
        super.init()
    }
}

struct TestView: View {
    @ObservedResults(TestItem.self, configuration: Realm.config) var items
    
    var body: some View {
        List {
            Text("items \(items.count)")
            Button("Add new") {
                $items.append(TestItem.init(id: .generate(), name: "GO"))
            }
            .buttonStyle(.bordered)
        }
    }
}


struct TestView_Preview: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
