//
//  PassportRegisterStepThree.swift
//  YuzPay
//
//  Created by applebro on 13/12/22.
//

import Foundation
import SwiftUI

struct PassportRegisterStepThree: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("паспортные\nданные")
                .font(.mont(.extraBold, size: 32))
                .foregroundColor(Color("accent_light"))
                .multilineTextAlignment(.leading)
                .padding(.bottom, Padding.medium)
            Spacer()
                .frame(maxWidth: .infinity)
            
            
        }
        .padding(.horizontal, Padding.medium)
    }
}

struct PassportRegisterStepThree_Preview: PreviewProvider {
    static var previews: some View {
        PassportRegisterStepThree()
    }
}

