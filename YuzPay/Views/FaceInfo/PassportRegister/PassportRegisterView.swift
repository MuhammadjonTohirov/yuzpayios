//
//  PassportRegister.swift
//  YuzPay
//
//  Created by applebro on 12/12/22.
//

import Foundation
import SwiftUI

struct PassportRegisterView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading) {
                    Text("Шаг 1 / 3:")
                        .font(.mont(.regular, size: 14))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .stroke(style: .init(dashPhase: 1))
                        )
                        .padding(.vertical, Padding.default)
                        .foregroundColor(Color("accent_light"))
                        .padding(.horizontal, Padding.medium)
                }

                PassportRegisterStepThree()
                
                Spacer()
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

struct PassportRegisterView_Preview: PreviewProvider {
    static var previews: some View {
        PassportRegisterView()
    }
}

