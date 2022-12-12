//
//  FacePayStartView.swift
//  YuzPay
//
//  Created by applebro on 12/12/22.
//

import Foundation
import SwiftUI

struct FacePayStartView: View {
    @State var buttonSize: CGRect = .zero
    var body: some View {
        GeometryReader  { proxy in
            Image("auth_intro_image")
                .resizable()
                .frame(height: UIScreen.screen.height * 0.83)
                .fixedSize(horizontal: false, vertical: true)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    Spacer()
                    
                    VStack(spacing: 0) {
                        Image("image_biometrics_identification")
                            .padding(.bottom, 54.f.height(0.1))
                            .padding(.top, 113.f.height(0.1))
                        Text("Оплачивайте покупки лицом!")
                            .font(.mont(.extraBold, size: 24))
                            .padding(.bottom, 36.f.height(0.1))
                        Text("Вам больше не понадобятся ни банковская карта, ни телефон. Просто подойдите к кассе и оплатите покупку!")
                            .font(.mont(.regular, size: 16))
                            .padding(.bottom, 20.f.height(0.1))
                        Text("Для доступа к данной функции потребуется лишь заполнить данные профиля.")
                            .font(.mont(.regular, size: 14))
                    }
                    .padding(Padding.default)
                    
                    Spacer()
                    
                    HoverButton(title: "Подключить услугу", backgroundColor: Color("accent_light_2"), titleColor: .white) {
                        
                    }
                    .padding(.horizontal, Padding.default)
                    .position(x: proxy.frame(in: .local).width / 2,
                              y: UIScreen.screen.height - buttonSize.maxY)

                    Button {
                        
                    } label: {
                        Text("Пропустить")
                            .font(.mont(.medium, size: 16))
                            .foregroundColor(Color("accent_light"))
                    }
                    .padding(.horizontal, Padding.default)
                    .padding(.vertical, Padding.default)
                    .position(x: proxy.frame(in: .local).width / 2,
                              y: UIScreen.screen.height - buttonSize.maxY)
                    .modifier(RectReader(rect: $buttonSize))
                }
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            }
        }
        .ignoresSafeArea()
    }
}

struct FacePayStartView_Preview: PreviewProvider {
    static var previews: some View {
        FacePayStartView()
    }
}

