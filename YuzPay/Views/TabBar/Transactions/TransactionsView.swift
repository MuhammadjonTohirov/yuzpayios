//
//  TransactionsView.swift
//  YuzPay
//
//  Created by applebro on 01/01/23.
//

import SwiftUI
import RealmSwift
import YuzSDK

struct TransactionsView: View {
    @ObservedResults(DTransactionSection.self, configuration: Realm.config) var sections;
    @State private var didAppear = false
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(sections.filter("items.@count > %d", 0).sorted(by: \.date, ascending: false)) { section in
                sectionBar(section)
                    .padding(.top, Padding.small)
                    .background(RoundedRectangle(cornerRadius: 16).foregroundColor(Color.systemBackground))
                    .padding(.vertical, 10)
                    .padding(.horizontal, Padding.default)
            }
            .scrollable()
        }
        .background(Color.secondarySystemBackground)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("bills".localize)
        .onAppear {
            MainNetworkService.shared.syncTransactions()
        }
    }
    
    
    // Not in use yet
    private var dateHeaderView: some View {
        HStack(alignment: .center) {
            Button {
                
            } label: {
                Image(systemName: "chevron.left")
            }

            Button {
                
            } label: {
                Text("Май 2022")
                    .font(.mont(.semibold, size: 16))
            }
            
            Button {
                
            } label: {
                Image(systemName: "chevron.right")
            }
        }
        .foregroundColor(Color.label)
        .padding(.bottom, Padding.medium)
        .frame(maxWidth: .infinity)
        .background(
            Rectangle()
                .foregroundColor(Color.systemBackground)
                .ignoresSafeArea()
        )
    }
    
    func sectionBar(_ section: DTransactionSection) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                sectionView(title: section.title)
                Spacer()
            }
            .padding(.vertical, Padding.small)

            ForEach(section.items.sorted(byKeyPath: "dateTime", ascending: false)) { item in
                rowItem(item)
                    .padding(.horizontal, Padding.default)
                    .frame(height: 59)
                
                if item != section.items.last {
                    Divider()
                }
            }
        }

    }
    
    func rowItem(_ item: DTransactionItem) -> some View {
        HStack(spacing: 0) {
            Rectangle()
                .width(45)
                .height(20)
                .foregroundColor(.clear)
                .overlay {
                    Text(item.dateTime.toExtendedString(format: "HH:mm"))
                        .font(.mont(.regular, size: 14))
                        .foregroundColor(Color.secondaryLabel)
                }
            
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.mont(.regular, size: 14))
                Text(item.status.text)
                    .font(.mont(.regular, size: 12))
                    .foregroundColor(item.status.color)
            }
            .padding(.leading, Padding.default)
            
            Spacer()
            
            Text(item.amount.asCurrency())
                .font(.mont(.regular, size: 14))
            
            Text(item.currency)
                .font(.mont(.regular, size: 14))
                .padding(.leading, 8)
        }
    }
    
    func sectionView(title: String) -> some View {
        Text(title)
            .font(.mont(.semibold, size: 16))
            .padding(.horizontal, Padding.default)
    }
}

extension DTransactionItem {
    var title: String {
        switch type {
        case .p2p:
            let cardNumber = (self.p2PCardNumber ?? "").maskAsMiniCardNumber
            return "\(cardNumber) / \(self.p2PCardHolder ?? "")"
        case .exchange:
            return "exchange".localize
        default:
            return self.agentName
        }
    }
}

struct TransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TransactionsView()
        }
        .onAppear {
            MockData.shared.createTransactions()
        }
    }
}
