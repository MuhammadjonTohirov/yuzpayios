//
//  TextFieldProtocol.swift
//  YuzPay
//
//  Created by applebro on 08/12/22.
//

import Foundation
import SwiftUI

protocol TextFieldProtocol: View {
    var text: String {get set}
    var left: (() -> any View) {get}
    var right: (() -> any View) {get}
}
