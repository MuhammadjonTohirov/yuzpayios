//
//  SideBarView.swift
//  YuzPay
//
//  Created by applebro on 18/12/22.
//

import Foundation
import SwiftUI

struct SideBarView: View {
    @ObservedObject var viewModel: SideBarViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                viewModel.onClickClose()
            } label: {
                Image("icon_x")
                    .padding(.horizontal, Padding.default)
                    .padding(.vertical, Padding.small)
            }
            
            ScrollView {
                innerBody
            }
            
            Spacer()
            
            Button {
                
            } label: {
                
                ZStack {
                    HStack {
                        Image(systemName: "gear")
                            .renderingMode(.template)
                        Spacer()
                    }
                    Text("settings".localize)
                        .font(.mont(.regular, size: 14))
                }
                .foregroundColor(Color("dark_gray"))
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(Color("gray").opacity(0.3))
                )
                .padding(.horizontal, Padding.default)
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    var innerBody: some View {
        VStack(alignment: .leading) {
            HStack {
                Image("image_avatar")
                    .resizable()
                    .frame(width: 88.f.sw(), height: 88.f.sw())
                
                VStack(alignment: .leading) {
                    Text("+998 93 585 24 15")
                        .font(.mont(.semibold, size: 16))
                    Text("Профиль не подтверждён")
                        .font(.mont(.regular, size: 12))
                        .foregroundColor(Color("accent_light"))
                    
                    Button {
                        
                    } label: {
                        Text("Подтвердить")
                            .font(.mont(.medium, size: 12))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundColor(Color("accent"))
                    )
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(Padding.default)
            
            ForEach($viewModel.menus) { item in
                item.wrappedValue.view {
                    viewModel.onClick(menu: item.wrappedValue)
                }
                .padding(Padding.default)
                .frame(height: 60.f.sh())
            }
            
            Spacer()
        }
    }
}

struct SideBarView_Preview: PreviewProvider {
    static var previews: some View {
        SideBarView(viewModel: SideBarViewModel())
    }
}

