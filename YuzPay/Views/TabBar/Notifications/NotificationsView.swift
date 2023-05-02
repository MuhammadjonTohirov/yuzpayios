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
    var notifications: Results<DNotification>?
    @Published private var notificationToken: NotificationToken?
    private var didAppear: Bool = false
    func onAppear() {
        if !didAppear {
            attachNotifications()
            didAppear = true
        }
    }
    
    private func attachNotifications() {
        if let realm = Realm.new {
            notifications = realm.objects(DNotification.self)
            notificationToken?.invalidate()
            notificationToken = notifications?.observe(on: .main, { [weak self] _ in
                self?.notifications = Realm.new?.objects(DNotification.self)
            })
        }
        
        // fetch from server
        
        Task {
            
            let notifs = await UserNetworkService.shared.getNotifications()

            Realm.new!.trySafeWrite {

                let dNotifs = notifs?.data?.map({
                    DNotification.build(withModel: $0)
                }) ?? []
                
                Realm.new!.add(dNotifs, update: .modified)
            }
        }
    }
}

struct NotificationsView: View {
    @ObservedObject private var viewModel = NotificationsViewModel()
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
        if let notifications = viewModel.notifications {
            ForEach(notifications) { notif in
                NotificationItemView(title: notif.logTitle ?? "", details: notif.logDetails ?? "", dateTime: Date.from(string: notif.createdDate ?? "") ?? Date(), type: .information)
            }
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
