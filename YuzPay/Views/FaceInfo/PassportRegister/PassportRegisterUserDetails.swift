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
        Text("Пожалуйста, проверьте Ваши личные данные. Если что-то не так, то Вы можете их поправить.")
            .font(.mont(.regular, size: 14))
            .foregroundColor(Color("label_color"))
            .multilineTextAlignment(.leading)
            .padding(.bottom, Padding.medium)

        YTextField(text: $lastName, placeholder: "Фамилия")
        .set(haveTitle: true)
        .set(hintColor: Color("dark_gray"))
        .modifier(YTextFieldBackgroundCleanStyle(padding: Padding.medium))
        .padding(.vertical, Padding.medium)
        
        YTextField(text: $firstName, placeholder: "Имя")
        .set(haveTitle: true)
        .set(hintColor: Color("dark_gray"))
        .modifier(YTextFieldBackgroundCleanStyle(padding: Padding.medium))
        .padding(.bottom, Padding.medium)
        
        YTextField(text: $middleName, placeholder: "Отчество")
        .set(haveTitle: true)
        .set(hintColor: Color("dark_gray"))
        .modifier(YTextFieldBackgroundCleanStyle(padding: Padding.medium))
        .padding(.bottom, Padding.medium)
        
        YTextField(text: $birthDate, placeholder: "Дата рождения")
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
