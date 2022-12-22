//
//  CardsAndWalletsViewModel.swift
//  YuzPay
//
//  Created by applebro on 22/12/22.
//

import Foundation
import RealmSwift

final class CardsAndWalletsViewModel: ObservableObject {
    @ObservedResults(
        DCard.self,
        configuration: Realm.config,
        where: {
            $0.status == .active
        }
    )
    var cards
}
