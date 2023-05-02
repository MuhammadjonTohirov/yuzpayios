//
//  AuthSelectLanguage.swift
//  YuzPay
//
//  Created by applebro on 17/12/22.
//

import Foundation
import YuzSDK
import SwiftUI

struct AuthSelectLanguage: View {
    @ObservedObject var viewModel = SelectLanguageViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                Text("welcome_text".localize)
                    .font(.mont(.extraBold, size: 32))
                    .foregroundColor(Color("accent_light"))
                    .padding(.bottom, 50)
                    .frame(width: 370, height: 200)
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            
            VStack(spacing: Padding.medium) {
                Spacer()
                
                FlatButton(title: Language.uzbek.name, borderColor: borderColor(.uzbek)) {
                    viewModel.select(language: .uzbek)
                }
                .padding(.horizontal, Padding.default * 2)
                
                FlatButton(title: Language.russian.name, borderColor: borderColor(.russian)) {
                    viewModel.select(language: .russian)
                }
                .padding(.horizontal, Padding.default * 2)
                
                FlatButton(title: Language.english.name, borderColor: borderColor(.english)) {
                    viewModel.select(language: .english)
                }
                .padding(.horizontal, Padding.default * 2)
                
                Spacer()
                
                HoverButton(title: "start".localize,
                            backgroundColor: Color("accent_light_2"),
                            titleColor: .white) {
                    viewModel.onClickNext()
                }
                .padding(.horizontal, Padding.large)
                .padding(.bottom, Padding.medium)
            }
        }
    }
    
    func borderColor(_ lan: Language) -> Color {
        lan == viewModel.selectedLanguage ? Color("accent") : Color("gray")
    }
}

struct AuthSelectLanguage_Preview: PreviewProvider {
    static var previews: some View {
        AuthSelectLanguage()
    }
}

