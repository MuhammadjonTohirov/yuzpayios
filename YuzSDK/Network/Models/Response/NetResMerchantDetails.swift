//
//  NetResMerchantDetails.swift
//  YuzPay
//
//  Created by applebro on 17/04/23.
//

import Foundation

public struct NetResMerchantDetails: Codable {
    public let id: Int?
    public let minAmount, maxAmount: Double?
    public let childID: Int?
    public let servicePrice, agentCommission, serviceCommission: Double?
    public let order: Int?
    public let serviceCommissionSum, paynetCommissionSum: Double?
    public let title: String?
    public let fields: [MField]?
    public let responseFields: [ResponseField]?
    public let services: [NetResMerchantDetails]?

    enum CodingKeys: String, CodingKey {
        case id, minAmount, maxAmount
        case childID = "childId"
        case servicePrice, agentCommission, serviceCommission, order, serviceCommissionSum, paynetCommissionSum, title, fields, responseFields, services
    }
}

public enum FieldType: String, Codable {
    case string = "STRING"
    case regexbox = "REGEXBOX"
    case datepopup = "DATEPOPUP"
    case number = "NUMBER"
    case phone = "PHONE"
    case money = "MONEY"
    case combobox = "COMBOBOX"
    case list = "LIST"
    case combomoth = "COMBOMONTH"
    case datebox = "DATEBOX"
}

public protocol MFieldProtocol: Identifiable {
    var id: Int {get}
    var order: Int? {get}
    var name: String {get}
    var title: String? {get}
    var fieldRequired: Bool? {get}
    var readOnly: Bool? {get}
    var fieldType: FieldType? {get}
    var isCustomerID: Bool? {get}
    var fieldSize: Int {get}
}

// MARK: - Field
public struct MField: Codable, Hashable, Identifiable, MFieldProtocol  {
    public let id: Int
    public let order: Int?
    public let name: String
    public let title: String?
    public let fieldRequired, readOnly: Bool?
    public let fieldType: FieldType? // STRING, REGEXBOX, DATEPOPUP, PHONE, STRING
    public let isCustomerID: Bool?
    public let fieldSize: Int

    enum CodingKeys: String, CodingKey {
        case id, order, name, title
        case fieldRequired = "required"
        case readOnly, fieldType
        case isCustomerID = "isCustomerId"
        case fieldSize
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    public static func == (lhs: MField, rhs: MField) -> Bool {
        return lhs.name == rhs.name
    }
    
    public init(id: Int, order: Int?, name: String, title: String?, fieldRequired: Bool?, readOnly: Bool?, fieldType: FieldType?, isCustomerID: Bool?, fieldSize: Int) {
        self.id = id
        self.order = order
        self.name = name
        self.title = title
        self.fieldRequired = fieldRequired
        self.readOnly = readOnly
        self.fieldType = fieldType
        self.isCustomerID = isCustomerID
        self.fieldSize = fieldSize
    }
}

// MARK: - ResponseField
public struct ResponseField: Codable {
    let fieldName: String
    let label: String?
    let order: Int
}

public extension NetResMerchantDetails {
    static var defaultDetails = """
        {
          "success": true,
          "data": [
            {
              "id": 2,
              "minAmount": 500,
              "maxAmount": 1500000,
              "childId": null,
              "servicePrice": 0,
              "agentCommission": 2.5,
              "serviceCommission": 0,
              "order": 1,
              "serviceCommissionSum": 0,
              "paynetCommissionSum": 0,
              "title": "Оплата",
              "fields": [
                {
                  "id": 151,
                  "order": null,
                  "name": "phone_number",
                  "title": "Номер телефона",
                  "required": true,
                  "readOnly": false,
                  "fieldType": "PHONE",
                  "isCustomerId": null,
                  "fieldSize": 9
                },
                {
                  "id": 152,
                  "order": null,
                  "name": "summa",
                  "title": "Сумма",
                  "required": true,
                  "readOnly": false,
                  "fieldType": "MONEY",
                  "isCustomerId": null,
                  "fieldSize": 10
                }
              ],
              "responseFields": [
                {
                  "fieldName": "agent_name",
                  "label": "Агент",
                  "order": -1
                },
                {
                  "fieldName": "agent_inn",
                  "label": "ИНН",
                  "order": 0
                },
                {
                  "fieldName": "provider_name",
                  "label": "Оператор",
                  "order": 1
                },
                {
                  "fieldName": "service_name",
                  "label": "Услуга",
                  "order": 2
                },
                {
                  "fieldName": "time",
                  "label": "Время",
                  "order": 3
                },
                {
                  "fieldName": "terminal_id",
                  "label": "Номер терминала",
                  "order": 4
                },
                {
                  "fieldName": "transaction_id",
                  "label": "Номер чека",
                  "order": 5
                },
                {
                  "fieldName": "phone_number",
                  "label": "Номер телефона",
                  "order": 7
                },
                {
                  "fieldName": "summa",
                  "label": "Оплачено",
                  "order": 8
                },
                {
                  "fieldName": "instruction1",
                  "label": null,
                  "order": 13
                },
                {
                  "fieldName": "loyalty_id",
                  "label": "Paynet ID",
                  "order": 14
                },
                {
                  "fieldName": "agent_cheque_message",
                  "label": null,
                  "order": 15
                },
                {
                  "fieldName": "ofd_productName1",
                  "label": "ИКПУ название",
                  "order": 83
                },
                {
                  "fieldName": "ofd_productName0",
                  "label": "ИКПУ название",
                  "order": 83
                },
                {
                  "fieldName": "ofd_receivedCash",
                  "label": "Наличные",
                  "order": 100
                },
                {
                  "fieldName": "ofd_receivedCard",
                  "label": "Банковские карты",
                  "order": 101
                },
                {
                  "fieldName": "ofd_time",
                  "label": "Время",
                  "order": 102
                },
                {
                  "fieldName": "ofd_isRefund",
                  "label": "Информация об отозванном чеке",
                  "order": 104
                },
                {
                  "fieldName": "ofd_receiptType",
                  "label": "Тип транзакци",
                  "order": 105
                },
                {
                  "fieldName": "ofd_name0",
                  "label": "Название",
                  "order": 106
                },
                {
                  "fieldName": "ofd_price0",
                  "label": "Цена",
                  "order": 108
                },
                {
                  "fieldName": "ofd_vat_amount0",
                  "label": "Сумма НДС",
                  "order": 109
                },
                {
                  "fieldName": "ofd_vatPercent0",
                  "label": "НДС в процентах",
                  "order": 110
                },
                {
                  "fieldName": "ofd_name1",
                  "label": "Название",
                  "order": 111
                },
                {
                  "fieldName": "ofd_productCode0",
                  "label": "ИКПУ код",
                  "order": 112
                },
                {
                  "fieldName": "ofd_productCode1",
                  "label": "ИКПУ код",
                  "order": 112
                },
                {
                  "fieldName": "ofd_price1",
                  "label": "Цена",
                  "order": 113
                },
                {
                  "fieldName": "ofd_amount1",
                  "label": "Количество",
                  "order": 114
                },
                {
                  "fieldName": "ofd_vat_amount1",
                  "label": "Сумма НДС",
                  "order": 115
                },
                {
                  "fieldName": "ofd_vatPercent1",
                  "label": "Протцент НДС",
                  "order": 116
                },
                {
                  "fieldName": "ofd_commisionInfo_tin0",
                  "label": "ИНН комитента",
                  "order": 117
                },
                {
                  "fieldName": "ofd_commisionInfo_tin1",
                  "label": "ИНН комитента",
                  "order": 118
                },
                {
                  "fieldName": "ofd_terminal_id",
                  "label": "ФМ номер",
                  "order": 119
                },
                {
                  "fieldName": "ofd_cheque_id",
                  "label": "Номер чека ОФД",
                  "order": 120
                },
                {
                  "fieldName": "ofd_fiscal_sign",
                  "label": "Фискальная признак",
                  "order": 121
                },
                {
                  "fieldName": "ofd_date_time",
                  "label": "Время транзакции ОФД",
                  "order": 124
                },
                {
                  "fieldName": "ofdqrcode",
                  "label": "QR код",
                  "order": 125
                }
              ],
              "services": []
            },
            {
              "id": 3513,
              "minAmount": 0,
              "maxAmount": 0,
              "childId": null,
              "servicePrice": 0,
              "agentCommission": 0,
              "serviceCommission": 0,
              "order": 462,
              "serviceCommissionSum": 0,
              "paynetCommissionSum": 0,
              "title": "Проверка номера",
              "fields": [
                {
                  "id": 1662,
                  "order": null,
                  "name": "phone_number",
                  "title": "Номер телефона",
                  "required": true,
                  "readOnly": false,
                  "fieldType": "PHONE",
                  "isCustomerId": null,
                  "fieldSize": 9
                }
              ],
              "responseFields": [
                {
                  "fieldName": "agent_name",
                  "label": "Агент",
                  "order": -1
                },
                {
                  "fieldName": "agent_inn",
                  "label": "ИНН",
                  "order": 0
                },
                {
                  "fieldName": "provider_name",
                  "label": "Оператор",
                  "order": 1
                },
                {
                  "fieldName": "service_name",
                  "label": "Услуга",
                  "order": 2
                },
                {
                  "fieldName": "time",
                  "label": "Время",
                  "order": 3
                },
                {
                  "fieldName": "terminal_id",
                  "label": "Номер терминала",
                  "order": 4
                },
                {
                  "fieldName": "transaction_id",
                  "label": "Номер чека",
                  "order": 5
                },
                {
                  "fieldName": "phone_number",
                  "label": "Номер телефона",
                  "order": 7
                },
                {
                  "fieldName": "check_status",
                  "label": "Статус номера",
                  "order": 10
                }
              ],
              "services": []
            }
          ],
          "error": null,
          "code": 200
        }
    """
    
    static var defaultDetailsObject: [NetResMerchantDetails] {
        do {
            let details = try JSONSerialization.jsonObject(with: defaultDetails.data(using: .utf8, allowLossyConversion: true)!) as! [String: Any]
            let data = try JSONSerialization.data(withJSONObject: details)
            let details2 = try JSONDecoder().decode(NetRes<[NetResMerchantDetails]>.self, from: data)
            return details2.data ?? []
        } catch let error {
            Logging.l(error.localizedDescription)
            return []
        }
    }
}
