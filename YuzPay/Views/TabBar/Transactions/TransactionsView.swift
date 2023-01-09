//
//  TransactionsView.swift
//  YuzPay
//
//  Created by applebro on 01/01/23.
//

import SwiftUI
import RealmSwift

struct TransactionsView: View {
    @ObservedResults(DTransactionSection.self, configuration: Realm.config) var sections;
    
    var body: some View {
        VStack(spacing: 0) {
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
                
            ForEach(sections) { section in
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
    }
    
    func sectionBar(_ section: DTransactionSection) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionView(title: section.title)

            ForEach(section.items) { item in
                rowItem(item)
                    .padding(.horizontal, Padding.default)
                    .frame(height: 59)
                
                if item != section.items.last {
                    Divider()
                }
            }
        }
        .padding(.top, Padding.small)
    }
    
    func rowItem(_ item: DTransactionItem) -> some View {
        HStack(spacing: 0) {
            Text(item.dateTime.toExtendedString(format: "mm:HH"))
                .font(.mont(.regular, size: 14))
                .foregroundColor(Color.secondaryLabel)
            
            VStack(alignment: .leading) {
                Text(item.agentName)
                    .font(.mont(.regular, size: 14))
                Text(item.status.text)
                    .font(.mont(.regular, size: 12))
                    .foregroundColor(item.status.color)
            }
            .padding(.leading, Padding.default)
            
            Spacer()
            
            Text(item.amount.asCurrency)
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