//
//  Text+Extension.swift
//  YuzPay
//
//  Created by applebro on 11/12/22.
//

import Foundation
import SwiftUI

extension Text {
    init(_ string: String, configure: ((inout AttributedString) -> Void)) {
        var attributedString = AttributedString(string)
        configure(&attributedString)
        self.init(attributedString)
    }
}
