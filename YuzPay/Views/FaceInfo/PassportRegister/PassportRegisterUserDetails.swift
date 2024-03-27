//
//  PassportRegisterUserDetails.swift
//  YuzPay
//
//  Created by applebro on 13/12/22.
//

import Foundation
import SwiftUI

struct PassportRegisterUserDetails: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var middleName: String
    @Binding var birthDate: String
    
    @ViewBuilder var body: some View {
        Text("check_personality".localize)
            .font(.mont(.regular, size: 14))
            .foregroundColor(Color("label_color"))
            .multilineTextAlignment(.leading)
            .padding(.bottom, Padding.medium)

        YTextField(text: $lastName, placeholder: "surname".localize)
        .set(haveTitle: true)
        .set(hintColor: Color("dark_gray"))
        .modifier(YTextFieldBackgroundCleanStyle(padding: Padding.medium))
        .padding(.vertical, Padding.medium)
        
        YTextField(text: $firstName, placeholder: "name".localize)
        .set(haveTitle: true)
        .set(hintColor: Color("dark_gray"))
        .modifier(YTextFieldBackgroundCleanStyle(padding: Padding.medium))
        .padding(.bottom, Padding.medium)
        
        YTextField(text: $middleName, placeholder: "family_name".localize)
        .set(haveTitle: true)
        .set(hintColor: Color("dark_gray"))
        .modifier(YTextFieldBackgroundCleanStyle(padding: Padding.medium))
        .padding(.bottom, Padding.medium)
        
        YTextField(text: $birthDate, placeholder: "birth_date".localize)
        .set(haveTitle: true)
        .set(hintColor: Color("dark_gray"))
        .modifier(YTextFieldBackgroundCleanStyle(padding: Padding.medium))
        .padding(.bottom, Padding.medium)
    }
}

struct PassportRegisterUserDetails_Preview: PreviewProvider {
    @State static var firstName = ""
    @State static var lastName = ""
    @State static var middleName = ""
    @State static var birthDate = ""
    
    static var previews: some View {
        PassportRegisterUserDetails(firstName: $firstName, lastName: $lastName, middleName: $middleName, birthDate: $birthDate)
    }
}
