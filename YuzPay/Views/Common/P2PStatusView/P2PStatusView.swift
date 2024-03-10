//
//  P2PStatusView.swift
//  YuzPay
//
//  Created by applebro on 10/03/24.
//

import Foundation
import SwiftUI
import YuzSDK

struct P2PStatusView: View {
    var amount: String
    var name: String
    @Environment(\.dismiss) var dismiss
    var transferId: Int
    
    @State
    private var showPdf = false
    
    var body: some View {
        Rectangle()
            .foregroundStyle(Color.accentColor)
            .ignoresSafeArea()
            .overlay {
                VStack(alignment: .center) {
                    Spacer()

                    Text("ready".localize)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 32, weight: .semibold))
                        .padding(.bottom, Padding.medium)
                        .padding(.top, Padding.default)

                    Text("transferred.n.to.u".localize(arguments: amount, name))
                        .font(.system(size: 24, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Padding.default)
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Circle()
                            .frame(width: 50, height: 50, alignment: .center)
                            .opacity(0.2)
                            .overlay {
                                Image(systemName: "square.and.arrow.down")
                                    .padding(.bottom, 4)
                            }
                        
                        Text("check".localize)
                            .font(.system(size: 12))
                    }
                    .onTapGesture {
                        showPdf = true
                    }
                    .padding(.bottom, Padding.default)

                    HoverButton(title: "close".localize,
                                backgroundColor: .init(uiColor: UIColor.white.withAlphaComponent(0.3)).colorInvert(),
                                titleColor: .white
                    ) {
                        dismiss.callAsFunction()
                    }
                    .padding(.bottom, Padding.medium)
                }
                .padding(.horizontal, Padding.medium)
                .frame(maxWidth: .infinity)
                .foregroundStyle(Color.white)
                .sheet(isPresented: $showPdf, content: {
                    PDFViewer(pdfURL: URL.base.appendingPath("api", "Client", "TransactionView", transferId))
                })
            }
    }
}

#Preview {
    P2PStatusView(amount: "1000 so'm", name: "Master •241", transferId: 0)
}
