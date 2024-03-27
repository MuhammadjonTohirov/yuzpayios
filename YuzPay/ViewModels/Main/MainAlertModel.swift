//
//  MainAlertModel.swift
//  YuzPay
//
//  Created by applebro on 22/04/23.
//

import SwiftUI

struct AButton {
    var title: String
    var type: ButtonType
    var action: () -> Void
    
    var body: some View {
        Button {
            withAnimation(.easeIn(duration: 0.2)) {
                action()
            }
        } label: {
            Rectangle()
                .frame(height: 40)
                .foregroundColor(.clear)
                .overlay {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(type == .normal ? .label : .systemRed)
                }
        }
        .transaction { tr in
            tr.animation = nil
        }
    }
}

enum ButtonType {
    case normal
    case destructive
}


final class MainAlertModel: ObservableObject {
    @Published var alert: Bool = false
    var title: String = ""
    var message: String = ""
    @Published var buttons: [AButton] = []
    
    init(alert: Bool = false, title: String = "", message: String = "", buttons: AButton...) {
        self.alert = alert
        self.title = title
        self.message = message
        self.buttons = buttons
    }
    
    func show(title: String, message: String) {
        self.title = title
        self.message = message
        withAnimation(.easeIn(duration: 0.2)) {
            self.alert = true
        }
        
        addButton(.init(title: "cancel".localize, type: .normal, action: { [weak self] in
            self?.hide()
        }))
    }
    
    func hide() {
        withAnimation(.easeIn(duration: 0.2)) {
            self.alert = false
        }
    }
    
    func addButton(_ button: AButton) {
        if !buttons.contains(where: {$0.title == button.title}) {
            self.buttons.append(button)
        }
    }
}
