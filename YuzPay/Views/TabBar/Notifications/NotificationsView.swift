//
//  NotificationsView.swift
//  YuzPay
//
//  Created by applebro on 09/01/23.
//

import Foundation
import SwiftUI
import RealmSwift
import YuzSDK

final class NotificationsViewModel: ObservableObject {
    
    private var didAppear: Bool = false
    func onAppear() {
        if !didAppear {
            didAppear = true
        }
        
        Task {
            await UserNetworkService.shared.syncNotifications()
        }
    }
}

struct NotificationsView: View {
    @ObservedResults(DNotification.self, configuration: Realm.config) var notifications
    @StateObject private var viewModel = NotificationsViewModel()
    var body: some View {
        List {
            notificationsView
        }
        .listStyle(.plain)
        .navigationTitle("notifications".localize)
        .onAppear {
            viewModel.onAppear()
        }
    }
    
    @ViewBuilder
    private var notificationsView: some View {
        ForEach(notifications) { notif in
            NotificationItemView(title: notif.logTitle ?? "", details: notif.logDetails ?? "", dateTime: Date.from(string: notif.createdDate ?? "") ?? Date(), type: .information)
        }
    }
}

struct NotificationsView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NotificationsView()
                .navigationTitle("notifications".localize)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
