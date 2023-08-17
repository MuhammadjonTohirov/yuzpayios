//
//  NotificationItemView.swift
//  YuzPay
//
//  Created by applebro on 09/01/23.
//

import Foundation
import SwiftUI

struct NotificationItemView: View {
    var title: String
    var details: String
    var dateTime: Date
    var type: NotificationType
    var body: some View {
        Button {} label: {
            HStack {
                Rectangle()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.clear)
                    .overlay {
                        type
                            .icon
                            .foregroundColor(.secondaryLabel)
                    }
                    .padding(Padding.default)
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .mont(.semibold, size: 14)
                    Text(details)
                        .mont(.regular, size: 12)

                    Text(
                        dateTime.toExtendedString(format: "dd.MM.yyyy HH:mm")
                    )
                    .mont(.regular, size: 12)
                    .foregroundColor(.secondaryLabel)
                }
            }
            .multilineTextAlignment(.leading)
        }
    }
}

struct NotificationItem_Preview: PreviewProvider {
    static var previews: some View {
        NotificationItemView(
            title: "Информационное уведомление",
            details: "Небольшое количество никому не нужной информации, которую Вы всё равно не прочтёте.",
            dateTime: Date(),
            type: .information)
    }
}
