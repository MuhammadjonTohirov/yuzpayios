//
//  Form.swift
//  YuzPay
//
//  Created by applebro on 21/04/23.
//

import Foundation
import SwiftUI
import YuzSDK

final class FieldItem: Identifiable, ObservableObject, Hashable {
    static func == (lhs: FieldItem, rhs: FieldItem) -> Bool {
        lhs.field.name == rhs.field.name
    }
    
    var id: Int {
        field.id
    }
    
    let field: MField
    @Published var text: String
    
    init(field: MField, text: String) {
        self.field = field
        self.text = text
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(field.name)
    }
}

struct FormModel {
    let id: Int?
    var minAmount, maxAmount: Double?
    let childID: Int?
    var servicePrice, agentCommission, serviceCommission: Double?
    let order: Int?
    let serviceCommissionSum, paynetCommissionSum: Double?
    let title: String?
    var fields: [FieldItem]?
    let responseFields: [ResponseField]?
    let services: [NetResMerchantDetails]?
    
    init(id: Int?, minAmount: Double?, maxAmount: Double?, childID: Int?, servicePrice: Double?, agentCommission: Double?, serviceCommission: Double?, order: Int?, serviceCommissionSum: Double?, paynetCommissionSum: Double?, title: String?, fields: [FieldItem]? = nil, responseFields: [ResponseField]?, services: [NetResMerchantDetails]?) {
        self.id = id
        self.minAmount = minAmount
        self.maxAmount = maxAmount
        self.childID = childID
        self.servicePrice = servicePrice
        self.agentCommission = agentCommission
        self.serviceCommission = serviceCommission
        self.order = order
        self.serviceCommissionSum = serviceCommissionSum
        self.paynetCommissionSum = paynetCommissionSum
        self.title = title
        self.fields = fields
        self.responseFields = responseFields
        self.services = services
    }
    
    static func create(with res: NetResMerchantDetails) -> FormModel {
        let requiredFields: [FieldItem] = (res.fields?.compactMap({.init(field: $0, text: "")}) ?? [])
        var form: FormModel = .init(id: res.id,
                                    minAmount: res.minAmount, maxAmount: res.maxAmount, childID: res.childID,
                                    servicePrice: res.servicePrice, agentCommission: res.agentCommission, serviceCommission: res.serviceCommission,
                                    order: res.order, serviceCommissionSum: res.serviceCommissionSum, paynetCommissionSum: res.paynetCommissionSum,
                                    title: res.title,
                                    fields: requiredFields,
                                    responseFields: res.responseFields, services: res.services)
        
        if let childID = res.childID {
            let child = res.services?.first(where: {$0.id == childID})
            form.minAmount = child?.minAmount
            form.maxAmount = child?.maxAmount
            form.agentCommission = child?.agentCommission
            form.serviceCommission = child?.serviceCommission
            
            child?.fields?.forEach({ field in
                if !(form.fields?.map({$0.field}) ?? []).contains(field) && (field.fieldRequired ?? false) {
                    form.fields?.append(
                        .init(
                            field: field,
                            text: child?.title ?? ""
                        )
                    )
                }
            })
        }
        
        if let fields = form.fields, fields.last?.field.fieldType != .money, let amountField = fields.first(where: {$0.field.fieldType == .money}) {
            form.fields?.removeAll(where: {$0.id == amountField.id})
            form.fields?.append(amountField)
        }
        
        form.minAmount = form.minAmount == 0 ? 5000 : form.minAmount
        form.maxAmount = form.maxAmount == 0 ? 50000000 : form.maxAmount
        
        if let fields = form.fields, !fields.contains(where: {$0.field.fieldType == .money}) {
            form.fields?.append(.init(field: .init(id: 21, order: 21, name: "amount", title: "amount", fieldRequired: true, readOnly: false, fieldType: .money, isCustomerID: false, fieldSize: 8), text: ""))
        }
        return form
    }
    
    var formView: some View {
        FormView(model: self)
    }
}

struct FormView: View {
    var model: FormModel
    
    var body: some View {
        VStack {
            if let fields = model.fields {
                ForEach(fields.filter({($0.field.fieldRequired ?? false) && !($0.field.readOnly ?? true)})) { field in
                    FieldView(field: field)
                }
                
                HStack {
                    if (model.maxAmount ?? 0) > 0 {
                        Text("\(Int(model.minAmount ?? 0)) - \(Int(model.maxAmount ?? 0))")
                            .font(.mont(.light, size: 12))
                            .foregroundColor(.placeholderText)
                    }
                    Spacer()
                }
                .padding(.horizontal, Padding.large)
            }
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Text("")
            }
            
            ToolbarItem(placement: .keyboard) {
                Button {
                    UIApplication.shared.endEditing()
                } label: {
                    Image(systemName: "keyboard.chevron.compact.down")
                }
            }
        }
    }
}
