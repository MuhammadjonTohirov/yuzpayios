//
//  UScrollView.swift
//  YuzPay
//
//  Created by applebro on 17/08/23.
//

import Foundation
import SwiftUI

//uiscrollview to swiftui

struct UScrollView : UIViewRepresentable {
    @Binding var startRefresh: Bool
    
    var content: () -> UIView
    var refreshControl = UIRefreshControl()
    
    func makeUIView(context: Context) -> UIScrollView {
        let view = UIScrollView()
        
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isDirectionalLockEnabled = true
        view.refreshControl = refreshControl
        
        let v = content()
        view.contentInsetAdjustmentBehavior = .never
        view.setContentOffset(.zero, animated: false)
        view.addSubview(v)

        v.translatesAutoresizingMaskIntoConstraints = false
        v.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        v.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        v.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        v.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        refreshControl.addTarget(context.coordinator, action: #selector(context.coordinator.onChangeValue(_:)), for: .valueChanged)
        refreshControl.attributedTitle = .init(.init("reloading".localize))
        return view
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        debugPrint("Refreshing is \(startRefresh)")
        if startRefresh {
            refreshControl.beginRefreshing()
        } else {
            refreshControl.endRefreshing()
            uiView.setContentOffset(.zero, animated: true)
        }
    }
    
//   create controller
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: UScrollView
        
        init(_ parent: UScrollView) {
            self.parent = parent
            debugPrint("Create uscrollview coordinator")
        }
        
        @objc func onChangeValue(_ refreshControl: UIRefreshControl) {
            debugPrint("On change")
            parent.startRefresh = true
        }
    }
}

extension View {
    var asUIView: UIView {
        UIHostingController(rootView: self).view
    }
}
