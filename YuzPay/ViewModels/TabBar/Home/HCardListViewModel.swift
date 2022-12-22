//
//  HCardListViewModel.swift
//  YuzPay
//
//  Created by applebro on 22/12/22.
//

import Foundation
import RealmSwift

final class HCardListViewModel: ObservableObject {
//    @Published var cards: Results<DCard>?
    @ObservedResults(DCard.self, configuration: Realm.config) var cards

    func onAppear() {
//        cards = Realm.new?.objects(DCard.self)
    }
}
