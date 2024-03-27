//
//  SideBarView.swift
//  YuzPay
//
//  Created by applebro on 18/12/22.
//

import Foundation
import SwiftUI
import YuzSDK
import Kingfisher

struct SideBarContent: View {
    @StateObject var viewModel: SideBarViewModel
    
    var isVerifiedUser: Bool {
        DataBase.userInfo?.isVerified ?? false
    }
    
    @State var showLogoutAlert = false
    @State var showIdentifier = false
    var fullName: String {
        guard let info = DataBase.userInfo else {
            return UserSettings.shared.userPhone ?? ""
        }
        
        return info.isVerified ? info.familyName?.nilIfEmpty ?? "" : (info.phoneNumber ?? "").format(with: "+998 XX XXX XX XX")
    }
    
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
                    .fullScreenCover(isPresented: $showIdentifier) {
                        UserIdentificationView()
                    }
            }
            
            Spacer()
            
            Button {
                showLogoutAlert = true
            } label: {
                ZStack {
                    HStack {
                        Image(systemName: "power")
                            .renderingMode(.template)
                        Spacer()
                    }
                    Text("logout".localize)
                        .font(.mont(.regular, size: 14))
                }
                .foregroundColor(.label)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(Color("gray").opacity(0.3))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color("gray").opacity(0.3), lineWidth: 1)
                        )
                
                        
                )
                .padding(.horizontal, Padding.default)
                .frame(maxWidth: .infinity)
            }
        }.onAppear {
            self.viewModel.onAppear()
        }
    }
    
    var innerBody: some View {
        VStack(alignment: .leading) {
            HStack {
                Button {
                    viewModel.onClickProfile()
                } label: {
                    KF(imageUrl: UserSettings.shared.userAvatarURL,
                       cacheKey: (UserSettings.shared.loginDate ?? Date()).toExtendedString(),
                       storageExpiration: .expired,
                       memoryExpiration: .expired
                    )
                    .frame(width: 88.f.sw(), height: 88.f.sw())
                    .background {
                        Circle()
                            .foregroundColor(.secondarySystemBackground)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text(fullName)
                        .font(.mont(.semibold, size: 16))

                    Button {
                        if !isVerifiedUser {
                            showIdentifier = true
                        } else {
                            viewModel.onClickProfile()
                        }
                    } label: {
                        Text(isVerifiedUser ? "verified".localize : "not_verified".localize)
                            .font(.mont(.medium, size: 12))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundColor(isVerifiedUser ? Color("accent") : .systemOrange)
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
        .alert("warning".localize, isPresented: $showLogoutAlert, actions: {
            Button {
            } label: {
                Text("cancel".localize)
            }

            Button {
                UserSettings.shared.clearUserDetails()
                
                mainRouter?.navigate(to: .auth)
            } label: {
                Text("logout".localize)
            }
        }, message: {
            Text("want_to_logout".localize)
        })
    }
}

struct SideBarView_Preview: PreviewProvider {
    static var previews: some View {
        SideBarContent(viewModel: SideBarViewModel())
    }
}

