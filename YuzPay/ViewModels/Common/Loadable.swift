//
//  Loadable.swift
//  YuzPay
//
//  Created by applebro on 21/02/23.
//

import SwiftUI

protocol Loadable: NSObject {
    var isLoading: Bool {get set}
    
    func showLoader()
    
    func hideLoader()
}

extension Loadable {
    func showLoader() {
        DispatchQueue.main.async {
            self.isLoading = true
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
}
