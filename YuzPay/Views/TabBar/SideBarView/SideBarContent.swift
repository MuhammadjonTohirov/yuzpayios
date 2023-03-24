//
//  SideBarView.swift
//  YuzPay
//
//  Created by applebro on 18/12/22.
//

import Foundation
import SwiftUI
import Kingfisher

struct SideBarContent: View {
    @StateObject var viewModel: SideBarViewModel
    
    var isVerifiedUser: Bool {
        UserSettings.shared.isVerifiedUser ?? false
    }
    
    @State var showLogoutAlert = false
    @State var showIdentifier = false
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
                        .border(Color("gray"), width: 1, cornerRadius: 8)
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
                    KF(imageUrl: UserSettings.shared.userAvatarURL, storageExpiration: .expired, memoryExpiration: .expired)
                        .frame(width: 88.f.sw(), height: 88.f.sw())
                        .background {
                            Circle()
                                .foregroundColor(.systemGray)
                        }
                }
                
                VStack(alignment: .leading) {
                    Text(UserSettings.shared.userPhone ?? "")
                        .font(.mont(.semibold, size: 16))

                    Button {
                        showIdentifier = true
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

