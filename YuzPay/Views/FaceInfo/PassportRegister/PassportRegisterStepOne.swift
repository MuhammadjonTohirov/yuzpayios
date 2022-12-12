//
//  PassportRegisterSetpOne.swift
//  YuzPay
//
//  Created by applebro on 12/12/22.
//

import Foundation
import SwiftUI

struct PassportRegisterStepOne: View {
    @State var passwordId: String = ""
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Шаг 1 / 3:")
                .font(.mont(.regular, size: 14))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .stroke(style: .init(dashPhase: 1))
                )
                .padding(.bottom, Padding.medium)
                .padding(.top, Padding.default)
                .foregroundColor(Color("accent_light"))
            
            Text("паспортные\nданные")
                .font(.mont(.extraBold, size: 32))
                .foregroundColor(Color("accent_light"))
                .padding(.bottom, Padding.medium)
            
            
            topView
            
            personalInfoView
            Spacer()
        }
        .padding(.horizontal, Padding.medium)
    }
    
    @ViewBuilder var personalInfoView: some View {
        YTextField(text: $passwordId, placeholder: "Серия и номер паспорта", right: {
            Image("icon_camera")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 16, height: 16)
                .padding(Padding.medium)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(Color("gray"))
                }
                .padding(Padding.small / 2)
        })
        .set(haveTitle: true)
        .set(hintColor: Color("dark_gray"))
        .modifier(YTextFieldBackgroundCleanStyle(padding: Padding.medium))
        .padding(.vertical, Padding.default)
        
        Divider()
        
        Text("Пожалуйста, проверьте Ваши личные данные. Если что-то не так, то Вы можете их поправить.")
            .font(.mont(.regular, size: 14))
            .padding(.top, Padding.default)
            .foregroundColor(Color("label_color"))
        
        YTextField(text: $passwordId, placeholder: "Фамилия")
        .set(haveTitle: true)
        .set(hintColor: Color("dark_gray"))
        .modifier(YTextFieldBackgroundCleanStyle(padding: Padding.medium))
        .padding(.vertical, Padding.medium)
        
        YTextField(text: $passwordId, placeholder: "Имя")
        .set(haveTitle: true)
        .set(hintColor: Color("dark_gray"))
        .modifier(YTextFieldBackgroundCleanStyle(padding: Padding.medium))
        .padding(.bottom, Padding.medium)
        
        YTextField(text: $passwordId, placeholder: "Отчество")
        .set(haveTitle: true)
        .set(hintColor: Color("dark_gray"))
        .modifier(YTextFieldBackgroundCleanStyle(padding: Padding.medium))
        .padding(.bottom, Padding.medium)
        
        YTextField(text: $passwordId, placeholder: "Дата рождения")
        .set(haveTitle: true)
        .set(hintColor: Color("dark_gray"))
        .modifier(YTextFieldBackgroundCleanStyle(padding: Padding.medium))
        .padding(.bottom, Padding.medium)
    }
    
    @ViewBuilder var topView: some View {
        Text("Паспортные данные необходимы, чтобы подтвердить Вашу личность и открыть полный доступ ко всем услугам.")
            .font(.mont(.regular, size: 15))
            .padding(.bottom, Padding.default)
        
        HStack(spacing: 16) {
            Image("icon_checkbox_on")
                .resizable()
                .frame(width: 20.f.sw(limit: 1.6), height: 20.f.sw(limit: 1.6))
                .onTapGesture {
                    
                }
            
            Text(
                "public_offer".localize, configure: { attr in
                    if let range = attr.range(of: "the_offer".localize) {
                        attr[range].foregroundColor = Color("accent_light")
                        attr[range].link = URL(string: "https://google.com")
                        attr[range].underlineStyle = NSUnderlineStyle.single
                    }
                }
            )
            .font(.mont(.regular, size: 16))
            
        }
        .padding(.top, Padding.default)
    }
    
    
}

struct PassportRegisterSetpOne_Preview: PreviewProvider {
    static var previews: some View {
        PassportRegisterStepOne()
    }
}


