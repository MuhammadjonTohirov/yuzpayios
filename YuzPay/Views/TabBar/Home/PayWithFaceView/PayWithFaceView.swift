//
//  PayWithFaceView.swift
//  YuzPay
//
//  Created by applebro on 22/12/22.
//

import Foundation
import SwiftUI

struct PayWithFaceView: View {
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 0) {
                Image("image_face_pay")
                    .resizable()
                    .sizeToFit(width: 150.f.sw())
            }

            HStack {
                Spacer()
                VStack(alignment: .leading) {
                    Text("Оплачивайте покупки лицом!")
                        .font(.mont(.medium, size: 20).smallCaps())
                        .padding(.bottom, 12.f.sh())
                    Text("без банковской карты")
                        .font(.mont(.regular, size: 14).smallCaps())
                    
                    Spacer()
                    
                    FlatButton(title: "continue".localize, borderColor: .clear, titleColor: Color.white) {
                        
                    }
                    .height(40)
                    .font(.mont(.regular, size: 15))
                    .background(RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(Color("accent")))
                }
                .frame(maxWidth: 203.f.sw())
            }
            .padding(.trailing, Padding.medium)
            .padding(.vertical, Padding.medium)
        }
        .cornerRadius(16, style: .circular)
        .frame(maxHeight: 200)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(Color.secondarySystemBackground)
        )
    }
}

struct PayWithFaceView_Preview: PreviewProvider {
    static var previews: some View {
        PayWithFaceView()
    }
}

