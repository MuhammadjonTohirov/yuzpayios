//
//  SettingsView.swift
//  YuzPay
//
//  Created by applebro on 17/01/23.
//

import Foundation
import SwiftUI
import AlertToast

struct SettingsView: View {
    @State var showChangePin = false
    @State var showChangeLang = false

    @State var showAlert = false
    @State var alertBody: AlertToast = .init(type: .complete(.systemGreen))
    @EnvironmentObject var viewModel: TabViewModel
    
    var body: some View {
        ZStack {
            NavigationLink("", isActive: $showChangePin) {
                PinCodeView(viewModel: .init(title: "change_pin".localize, reason: .setup, onResult: { isOK in
                    isOK ? showChangePin.toggle() : ()
                    isOK ? alert("success_pin_change".localize) : ()
                }))
            }
            
            NavigationLink("", isActive: $showChangeLang) {
                List {
                    Button {
                        UserSettings.shared.language = .uzbek
                        self.showChangeLang = false
                        self.viewModel.update = Date()
                    } label: {
                        HStack {
                            Text(Language.uzbek.name)
                            Spacer()
                            if UserSettings.shared.language == .uzbek {
                                Image(systemName: "checkmark.circle")
                            }
                        }
                    }
                    
                    Button {
                        UserSettings.shared.language = .russian
                        self.showChangeLang = false
                        self.viewModel.update = Date()
                    } label: {
                        HStack {
                            Text(Language.russian.name)
                            Spacer()
                            if UserSettings.shared.language == .russian {
                                Image(systemName: "checkmark.circle")
                            }
                        }
                    }
                    
                    Button {
                        UserSettings.shared.language = .english
                        self.showChangeLang = false
                        self.viewModel.update = Date()
                    } label: {
                        HStack {
                            Text(Language.english.name)
                            Spacer()
                            if UserSettings.shared.language == .english {
                                Image(systemName: "checkmark.circle")
                            }
                        }
                    }
                }
                .mont(.regular, size: 14)
                .navigationTitle("language".localize)
            }
            
            innerBody
        }
    }
    @State var showDeleteAccountAlert = false
    var innerBody: some View {
        VStack {
            Text("settings".localize)
                .font(.system(size: 16), weight: .semibold)
                .padding()

            RowButton(
                icon: Image("icon_language"),
                text: "language".localize,
                details: UserSettings.shared.language?.name ?? "English",
                onClick: {
                    showChangeLang = true
                }) {
                    AnyView(
                        RightChevron()
                    )
                }
            
            RowButton(
                icon: Image("icon_pin_2"),
                text: "change_pin".localize,
                onClick: {
                    showChangePin = true
                }) {
                    AnyView(
                        RightChevron()
                    )
                }
            
            RowButton(
                icon: Image("icon_trash 1"),
                text: "delete_account".localize,
                onClick: {
                    showDeleteAccountAlert = true
                })
            
            Spacer()
        }
        .alert("warning".localize, isPresented: $showDeleteAccountAlert, actions: {
            Button {
            } label: {
                Text("cancel".localize)
            }

            Button {
                UserSettings.shared.appPin = nil
                UserSettings.shared.userInfoDetails = nil
                mainRouter?.navigate(to: .auth)
            } label: {
                Text("delete".localize)
            }
            .foregroundColor(.systemRed)
            
            
        }, message: {
            Text("want_to_delete_account".localize)
        })
        .padding(.horizontal, Padding.default)
        .navigationBarTitleDisplayMode(.inline)
        .toast($showAlert, alertBody, duration: 1)
    }
    
    func alert(_ message: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.alertBody = .init(displayMode: .hud, type: .complete(.accentColor), title: message)
            self.showAlert = true
        }
    }
}

struct SettingsView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
                .environmentObject(TabViewModel())
        }
    }
}
