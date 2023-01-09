//
//  OrderCardView.swift
//  YuzPay
//
//  Created by applebro on 02/01/23.
//

import Foundation
import SwiftUI
import SwiftUIX

class OrderCardViewModel: ObservableObject {
    var shouldDismiss: Bool = false {
        didSet {
            if shouldDismiss {
                showCardTypeView = false
                onDismiss?()
            }
        }
    }
    
    @Published var showCardTypeView: Bool = false
    var onDismiss: (() -> Void)?
}

struct OrderCardView: View {
    @StateObject var viewModel = OrderCardViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            NavigationLink("", isActive: $viewModel.showCardTypeView) {
                SelectCardTypeView()
                    .environmentObject(viewModel)
            }
            
            selectBank
        }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("order_card".localize)
            .onAppear {
                viewModel.onDismiss = {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        dismiss()
                    }
                }
            }
    }
    
    func title(_ text: String) -> some View {
        Text(text)
            .font(.mont(.semibold, size: 28.f.sh()))
            .padding(.horizontal, Padding.default)
            .padding(.top, Padding.default)
    }

    var selectBank: some View {
        VStack(alignment: .leading, spacing: 0) {
            title("select_bank".localize)
            
            VStack(spacing: Padding.default) {
                bankCard {
                    Image("image_anor_bank")
                        .resizable(true)
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 24.f.sh())
                }
                .onTapGesture {
                    viewModel.showCardTypeView = true
                }
                
                bankCard {
                    Image("image_kapital")
                        .resizable(true)
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 20.f.sh())
                }
                
                bankCard {
                    Image("image_trastbank")
                        .resizable(true)
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 24.f.sh())
                }
            }
            .padding(.horizontal, Padding.default)
            .padding(.top, Padding.default)
            .scrollable()
        }
    }
        
    func row(title: String, detail: String, isOdd: Bool = false) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(detail)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.leading, Padding.small)
                .lineLimit(2)
                .multilineTextAlignment(.trailing)
                
        }
        .font(.mont(.regular, size: 14))
        .padding(.vertical, 2)
        .foregroundColor(.white.opacity(0.7))
        .padding(.horizontal, Padding.default)
        .background(!isOdd ? .clear : .white.opacity(0.2))
        .padding(.top, 3)
    }

    @ViewBuilder
    func cardDetails() -> some View {
        row(title: "address".localize + ":", detail: "150, Obod turmush, Fergana")
        
        row(title: "phone_number".localize + ":", detail: "+998 93 585-94-14", isOdd: true)
        
        row(title: "fax".localize + ":", detail: "+998 73 123-55-31")
            .padding(.bottom, Padding.small)
    }
    
    func bankCard(image: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                image()
                
                Spacer()
            }
            .padding(Padding.medium)

            cardDetails()
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(Color("accent"))
        )
    }
}

struct OrderCardView_Preview: PreviewProvider {
    static var previews: some View {
        StackNavigationView {
            OrderCardView()
        }
    }
}
