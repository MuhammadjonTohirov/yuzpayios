//
//  SettingsView.swift
//  YuzPay
//
//  Created by applebro on 17/01/23.
//

import Foundation
import SwiftUI
import YuzSDK

struct SettingsView: View {
    @StateObject var viewModel: SettingsViewModel

    @State private var alertBody: AlertToast = .init(type: .complete(.init(uiColor: .systemGreen)))
    @EnvironmentObject var tabViewModel: TabViewModel
    
    var body: some View {
        ZStack {
            NavigationLink("", isActive: $viewModel.showChangePin) {
                PinCodeView(viewModel: .init(title: "change_pin".localize, reason: .setup, onResult: { isOK in
                    isOK ? viewModel.showPin() : ()
                    isOK ? alert("success_pin_change".localize) : ()
                }))
            }
            
            NavigationLink("", isActive: $viewModel.showChangeLang) {
                List {
                    Button {
                        UserSettings.shared.language = .uzbek
                        self.viewModel.hideChangeLanguage()
                        self.tabViewModel.update = Date()
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
                        self.viewModel.hideChangeLanguage()
                        self.tabViewModel.update = Date()
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
                        self.viewModel.hideChangeLanguage()
                        self.tabViewModel.update = Date()
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
    private var innerBody: some View {
        VStack {
            Text("settings".localize)
                .font(.mont(.semibold, size: 16))
                .padding()

            RowButton(
                icon: Image("icon_language"),
                text: "language".localize,
                details: UserSettings.shared.language?.name ?? "English",
                onClick: {
                    viewModel.showChangeLanguage()
                }) {
                    AnyView(
                        RightChevron()
                    )
                }
            
            RowButton(
                icon: Image("icon_pin_2"),
                text: "change_pin".localize,
                onClick: {
                    viewModel.showPin()
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
                viewModel.deleteAccount()
            } label: {
                Text("delete".localize)
            }
            .foregroundColor(.init(uiColor: .systemRed))
            
            
        }, message: {
            Text("want_to_delete_account".localize)
        })
        .padding(.horizontal, Padding.default)
        .navigationBarTitleDisplayMode(.inline)
        .toast($viewModel.showAlert, alertBody, duration: 1)
    }
    
    private func alert(_ message: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.alertBody = .init(displayMode: .alert, type: .complete(.init(uiColor: .systemGray)), title: message)
            self.viewModel.showDeleteAccountAlert()
        }
    }
}

struct SettingsView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView(viewModel: SettingsViewModel())
                .environmentObject(TabViewModel(dataService: TabDataService()))
        }
    }
}
