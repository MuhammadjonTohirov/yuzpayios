//
//  PassportRegisterStepTwo.swift
//  YuzPay
//
//  Created by applebro on 12/12/22.
//

import Foundation
import SwiftUI

struct PassportRegisterStepTwo: View {
    @State var firstName = ""
    @State var lastName = ""
    @State var middleName = ""
    @State var birthDate = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("passport_data".localize)
                .font(.mont(.extraBold, size: 32))
                .foregroundColor(Color("accent_light"))
                .multilineTextAlignment(.leading)
                .padding(.bottom, Padding.medium)

            PassportRegisterUserDetails(firstName: $firstName, lastName: $lastName, middleName: $middleName, birthDate: $birthDate)
            Spacer()
        }
        .padding(.horizontal, Padding.medium)
    }
}

struct PassportRegisterStepTwo_Preview: PreviewProvider {
    static var previews: some View {
        PassportRegisterStepTwo()
    }
}

