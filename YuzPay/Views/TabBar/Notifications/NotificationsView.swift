//
//  NotificationsView.swift
//  YuzPay
//
//  Created by applebro on 09/01/23.
//

import Foundation
import SwiftUI

struct NotificationsView: View {
    var body: some View {
        List {
            NotificationItemView(
                title: "Информационное уведомление",
                details: "Небольшое количество никому не нужной информации, которую Вы всё равно не прочтёте.",
                dateTime: Date(),
                type: .information)
            .listRowSeparator(.hidden, edges: .top)

            NotificationItemView(
                title: "Информационное  уведомление",
                details: "Небольшое количество никому не нужной информации, которую Вы всё равно не прочтёте.",
                dateTime: Date(),
                type: .blockCard)
            
            NotificationItemView(
                title: "Информационное уведомление",
                details: "Небольшое количество никому не нужной информации, которую Вы всё равно не прочтёте.",
                dateTime: Date(),
                type: .technical)
        }
        .listStyle(.plain)
        .navigationTitle("notifications".localize)
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
