//
//  SideView.swift
//  YuzPay
//
//  Created by applebro on 17/08/23.
//

import Foundation
import SwiftUI

struct SideBarView: View {
    @StateObject var sideViewModel: SideBarViewModel
    
    @State var sideMenuOffset: CGPoint = .zero
    @Binding var showSideMenu: Bool
    
    var sideMenuWidth: CGFloat {
        UIScreen.screen.width * 0.8
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(Color("black").opacity(0.5))
                .ignoresSafeArea()
                .opacity(Double(1 - abs(sideMenuOffset.x) / sideMenuWidth))
                .zIndex(1)
                .onTapGesture {
                    hideSideBar()
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged({ value in
                            let distance = value.startLocation.x - value.location.x
                            onDragSideMenu(distance.limitBottom(0))
                        })
                        .onEnded({ value in
                            onEndDragSideMenu(value.predictedEndTranslation)
                        })
                )
                .onChange(of: showSideMenu) { newValue in
                    newValue ? showSideBar() : hideSideBar()
                }
            Rectangle()
                .foregroundColor(Color("background"))
                .ignoresSafeArea()
                .frame(width: sideMenuWidth)
                .zIndex(2)
                .overlay {
                    // -MARK: Tab bar view
                    SideBarContent(viewModel: sideViewModel)
                }
                .offset(x: sideMenuOffset.x)
        }
        .onAppear {
            sideMenuOffset = CGPoint(x: -sideMenuWidth, y: 0)
        }
    }
    
    private func showSideBar() {
        withAnimation(.easeIn(duration: 0.2)) {
            self.sideMenuOffset.x = 0
            self.showSideMenu = true
        }
    }
    
    private func hideSideBar() {
        withAnimation(.easeOut(duration: 0.2)) {
            self.sideMenuOffset.x = -UIScreen.screen.width * 0.8
            self.showSideMenu = false
        }
    }
    
    private func onDragSideMenu(_ value: CGFloat) {
        self.sideMenuOffset.x = -abs(value)
    }
    
    private func onEndDragSideMenu(_ predictedEndTransition: CGSize) {
        if abs(predictedEndTransition.width) > 150 {
            hideSideBar()
        } else {
            showSideBar()
        }
    }
    
    private func onEndOpeningSideMenu(_ predictedEndTransition: CGSize) {
        if abs(predictedEndTransition.width) >= 150 {
            showSideBar()
        } else {
            hideSideBar()
        }
    }
    
}
