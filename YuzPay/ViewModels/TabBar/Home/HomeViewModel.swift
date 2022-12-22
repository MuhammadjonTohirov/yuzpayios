//
//  HomeViewModel.swift
//  YuzPay
//
//  Created by applebro on 18/12/22.
//

import Foundation
import RealmSwift

enum HomeViewRoute {
    case menu
    case notification
}

protocol HomeViewDelegate: NSObject {
    func homeView(model: HomeViewModel, onClick route: HomeViewRoute)
}

final class HomeViewModel: NSObject, ObservableObject {
    weak var delegate: HomeViewDelegate?
    @Published var searchText: String = ""
    
    lazy var cardListViewModel: HCardListViewModel = {
        return HCardListViewModel()
    }()
    
    func onAppear() {

    }
    
    func onClickMenu() {
        delegate?.homeView(model: self, onClick: .menu)
    }
    
    func onNotification() {
        delegate?.homeView(model: self, onClick: .notification)
    }
}
