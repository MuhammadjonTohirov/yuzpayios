//
//  UserProfileView.swift
//  YuzPay
//
//  Created by applebro on 04/02/23.
//

import SwiftUI
import RealmSwift
import YuzSDK

struct UserProfileView: View {
    @State private var showDevices = false

    @ObservedResults(DUserSession.self, configuration: Realm.config)
    private var sections;
    
    @ObservedResults(DUserInfo.self, configuration: Realm.config)
    private var userInfoList;
    
    private var userInfo: DUserInfo? {
        userInfoList.first
    }
    
    var body: some View {
        ZStack {
            innerBody
                .sheet(isPresented: $showDevices) {
                    NavigationView {
                        List(sections) { dev in
                            deviceItemView(title: dev.userAgent,
                                           detail: dev.clientIP,
                                           date: Date.from(string: dev.loginTime)?.toExtendedString(format: "HH:mm, dd/MM/YYYY") ?? "")
                        }
                        .navigationTitle("devices".localize)
                    }
                }
        }
        .onAppear {
            
        }
    }
    
    var innerBody: some View {
        VStack(alignment: .leading) {
            VStack {
                KF(imageUrl: UserSettings.shared.userAvatarURL)
                    .frame(width: 120, height: 120)
                    .padding(.vertical, Padding.small)
                
                Text(userInfo?.familyName ?? "")
                    .mont(.semibold, size: 21)
                
                Text("+998\((userInfo?.phoneNumber ?? "").format(with: "XX XXX XX XX"))")
                    .mont(.regular, size: 14)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, (Padding.large * 2).sh())
            .padding(.top, Padding.large.sh())
            .background(
                Rectangle()
                    .cornerRadius(100, corners: [.bottomLeft, .bottomRight])
                    .ignoresSafeArea()
                    .foregroundColor(.secondarySystemBackground)
            )
            
            VStack(alignment: .leading) {
                rowItem(
                    title: "address".localize + ":",
                    description: userInfo?.address?.nilIfEmpty ?? "-"
                )
                rowItem(title: "passport_id".localize + ":", description: userInfo?.passportNumber?.nilIfEmpty ?? "-")
                rowItem(title: "is_user_verified".localize + ":", description: "\(userInfo?.verificationStatus ?? "-")")
            }
            .padding(.horizontal, Padding.default)
                
            Divider()
            
            Button {
                showDevices = true
            } label: {
                HStack {
                    Text("devices".localize)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
            }
            .frame(height: 60)
            .padding(.horizontal, Padding.default)

            Spacer()
        }
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                Text("profile".localize)
                    .mont(.bold, size: 20)
            }
        })
    }
    
    func rowItem(title: String, description: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .mont(.medium, size: 12)
                .foregroundColor(.secondaryLabel)
            
            Text(description)
                .mont(.medium, size: 14)
        }
        .frame(height: 60)
    }
    
    func deviceItemView(title: String, detail: String, date: String) -> some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .mont(.regular, size: 14)
                
                Text(detail)
                    .mont(.semibold, size: 14)
                    .foregroundColor(.systemBlue)
            }
            .padding(.bottom, Padding.small)
            
            Text(date)
                .mont(.regular, size: 12)
                .foregroundColor(.secondaryLabel)
        }
        .padding(.vertical, Padding.small / 2)
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserProfileView()
        }
    }
}
