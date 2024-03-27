//
//  SimpleOrderCardView.swift
//  YuzPay
//
//  Created by applebro on 11/05/23.
//

import SwiftUI
import YuzSDK

// MARK: - Simple Order Card View
struct SimpleOrderCardView: View {
    @State fileprivate var buttons: [RowButtonItem] = []
    @State fileprivate var selectedBank: BankType?
    @State fileprivate var cardType: CreditCardType = .humo
    @State fileprivate var address: AddressValue?
    @State fileprivate var isFormOkay = false
    @State private var selectedButton: RowButtonItem?
    @Environment(\.dismiss) private var dismiss
    @State private var showNext: Bool = false
    
    @State private var showToast: Bool = false
    @State private var toast: AlertToast = .init(displayMode: .alert, type: .loading)
    
    @State private var showReceipt: Bool = false
    @State private var receiptRows: [ReceiptRowItem] = []
    
    var body: some View {
        ZStack {
            NavigationLink("", destination: nextView, isActive: $showNext)
            innerBody
                .toast($showToast, toast, duration: 0.8)
        }
    }
    
    var innerBody: some View {
        VStack(spacing: 12) {
            ForEach(buttons) { button in
                switch button.type {
                case .bank:
                    row(title: button.type.title, subtitle: button.subtitle ?? button.placeholder, button.subtitle == nil)
                        .onTapGesture {
                            selectedButton = button
                            showNext = true
                        }
                case .custom:
                    Text("Go to custom view")
                default:
                    if selectedBank != nil {
                        row(title: button.type.title, subtitle: button.subtitle ?? button.placeholder, button.subtitle == nil)
                            .onTapGesture {
                                selectedButton = button
                                showNext = true
                            }
                    }
                }
            }
            
            Spacer()
            
            FlatButton(title: "next".localize) {
                self.showOrderReceipt()
            }
            .opacity(isFormOkay ? 1 : 0)
        }
        .onChange(of: address ?? .init(), perform: { newValue in
            if var button = buttons.first(where: {$0.type == .address}), let index = buttons.firstIndex(of: button) {
                button.subtitle = newValue.info
                buttons.remove(at: index)
                buttons.insert(button, at: index)
            }
            
            isFormOkay = newValue.district.id != -1
        })
        .onChange(of: cardType, perform: { newValue in
            if var button = buttons.first(where: {$0.type == .card}), let index = buttons.firstIndex(of: button) {
                button.subtitle = newValue.name
                buttons.remove(at: index)
                buttons.insert(button, at: index)
            }
        })
        .onChange(of: selectedBank, perform: { newValue in
            if var button = buttons.first(where: {$0.type == .bank}), let index = buttons.firstIndex(of: button) {
                button.subtitle = newValue?.id.localize
                buttons.remove(at: index)
                buttons.insert(button, at: index)
            }
            
            isFormOkay = selectedBank != nil
        })
        .padding(.horizontal, Padding.default)
        .sheet(isPresented: $showReceipt, content: {
            NavigationView {
                ReceiptAndPayView(rows: $receiptRows)
                    .set(showCards: false)
                    .set(onClickSubmit: {cardId in
                        self.orderCard()
                    })
                    .set(submitButtonTitle: "order".localize)
                    
                    .navigationTitle("order_card".localize)
            }
        })
        .onAppear {
            if buttons.isEmpty {
                buttons.append(.init(type: .bank))
                buttons.append(.init(type: .card, subtitle: cardType.name))
                buttons.append(.init(type: .address))
            }
        }
    }
    
    private func row(title: String, subtitle: String, _ isPlaceholder: Bool = true) -> some View {
        SimpleRowButton(title: title, subtitle: subtitle, isPlaceholder: isPlaceholder)
    }
    
    @ViewBuilder
    private var nextView: some View {
        switch selectedButton?.type {
        case .bank:
            BankListView(selectedBank: $selectedBank)
                .navigationTitle(selectedButton?.placeholder ?? "")
        case .card:
            CardTypeListView(selectedCardType: $cardType)
                .navigationTitle(selectedButton?.placeholder ?? "")
        case .address:
            InsertAddressView(address: $address)
                .navigationTitle(selectedButton?.placeholder ?? "")
        default:
            Text("Custom view")
        }
    }
    
    private func orderCard() {
        guard let address else {
            return
        }
        
        Task(priority: .high) {
            let isOK = await MainNetworkService.shared.orderCard(
                req: .init(
                    regionID: address.region.id,
                    district: address.district.id,
                    street: address.street,
                    address: address.homeNumber, note: address.note,
                    bankID: 0, type: cardType.code)
            )
            
            if isOK {
                await MainActor.run(body: {
                    self.showAlert(.init(displayMode: .alert, type: .regular, title: "card_order_success".localize))
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                        self.dismiss()
                    }
                })
            } else {
                self.showAlert(.init(displayMode: .alert, type: .error(.systemRed), title: "card_order_failure".localize))
            }
        }
    }
    
    private func showOrderReceipt() {
        guard let selectedBank, let address else {
            return
        }
        
        self.receiptRows = [
            .init(name: "bank".localize, value: selectedBank.id),
            .init(name: "card".localize, value: cardType.name),
            .init(name: "address".localize, value: address.info),
            .init(name: "date".localize, value: Date().toExtendedString(format: "HH:mm, dd/MM/YYYY"))
        ]
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.3) {
            self.showReceipt = true
        }
    }
    
    private func showAlert(_ alert: AlertToast) {
        self.toast = alert
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.showToast = true
        }
    }
}


// MARK: - Order Virtual Card
struct SimpleVirtualCardOrderView: View {
    @State fileprivate var button: RowButtonItem = .init(type: .card)
    @State fileprivate var cardType: CreditCardType = .humo
    @State private var showCards = false
    
    @State private var showToast: Bool = false
    @State private var toast: AlertToast = .init(displayMode: .alert, type: .loading)
    
    @State private var showReceipt: Bool = false
    @State private var receiptRows: [ReceiptRowItem] = []

    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            NavigationLink("", isActive: $showCards) {
                CardTypeListView(selectedCardType: $cardType)
                    .navigationTitle(button.placeholder)
            }
            
            VStack {
                SimpleRowButton(
                    title: button.type.title, subtitle: cardType.name, isPlaceholder: false)
                .onTapGesture {
                    showCards = true
                }
                
                Spacer()
                
                FlatButton(title: "next".localize) {
                    self.showOrderReceipt()
                }
            }
        }
        .onChange(of: cardType, perform: { newValue in
            button.subtitle = newValue.name
        })
        .sheet(isPresented: $showReceipt, content: {
            NavigationView {
                ReceiptAndPayView(rows: $receiptRows)
                    .set(showCards: false)
                    .set(onClickSubmit: {cardId in
                        self.orderVirtualCard()
                    })
                    .set(submitButtonTitle: "order".localize)
                    
                    .navigationTitle("order_card".localize)
            }
        })
        .padding(.horizontal, Padding.default)
        .toast($showToast, toast, duration: 0.8)
    }
    
    private func showOrderReceipt() {
        self.receiptRows = [
            .init(name: "card".localize, value: cardType.name),
            .init(name: "date".localize, value: Date().toExtendedString(format: "HH:mm, dd/MM/YYYY"))
        ]
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.3) {
            self.showReceipt = true
        }
    }
    
    private func orderVirtualCard() {
        Task {
            let isOK = await MainNetworkService.shared.orderVirtualCard(req: .init(cardType.code))
            
            if isOK {
                await MainActor.run(body: {
                    self.showAlert(.init(displayMode: .alert, type: .regular, title: "card_order_success".localize))
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                        self.dismiss()
                    }
                })
            } else {
                self.showAlert(.init(displayMode: .alert, type: .error(.systemRed), title: "card_order_failure".localize))
            }
        }
    }
    
    private func showAlert(_ alert: AlertToast) {
        self.toast = alert
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.showToast = true
        }
    }
}

struct SimpleOrderCardView_Previews: PreviewProvider {
    @State static var region: (id: Int, name: String)?
    static var previews: some View {
        NavigationStack {
            SimpleOrderCardView()
        }
    }
}

// MARK: - Row Type
fileprivate enum RowType: Equatable {
    case bank
    case card
    case address
    case custom(title: String)
    
    var title: String {
        switch self {
        case .bank:
            return "bank".localize
        case .card:
            return "card".localize
        case .address:
            return "address".localize
        case let .custom(title):
            return title
        }
    }
    
    var placeholder: String {
        switch self {
        case .bank:
            return "select_bank".localize
        case .card:
            return "select_card_type".localize
        case .address:
            return "select_address".localize
        case .custom(let title):
            return "custom_\(title)".localize
        }
    }
    
}

// MARK: - RowButtonItem
fileprivate struct RowButtonItem: Identifiable, Hashable {
    static func == (lhs: RowButtonItem, rhs: RowButtonItem) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: String {
        type.title
    }
    
    var type: RowType
    var placeholder: String {
        type.placeholder
    }
    
    dynamic var subtitle: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    
}

// MARK: - Bank Type
fileprivate enum BankType: Identifiable, Hashable {
    var id: String {
        switch self {
        case .kapital:
            return "kapital_bank"
        case .anor:
            return "anor_bank"
        }
    }
    
    case kapital
    case anor
    
    var imageName: String {
        switch self {
        case .kapital:
            return "image_kapital"
        case .anor:
            return "image_anor_bank"
        }
    }
}

// MARK: - Bank List View
fileprivate struct BankListView: View {
    @Binding var selectedBank: BankType?
    @Environment(\.dismiss) var dismiss
    var banks: [BankType] = [.kapital]
    
    var body: some View {
        ForEach(banks) { bank in
            bankCard {
                Image(bank.imageName)
                    .resizable(true)
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 20.f.sh())
            }
            .onTapGesture {
                selectedBank = bank
                dismiss()
            }
        }
        .padding(.horizontal, Padding.default)
        .scrollable()
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

// MARK: - Card Type List
fileprivate struct CardTypeListView: View {
    @State private var cardTypes: [CreditCardType] = [.humo, .visa, .master]
    @Binding var selectedCardType: CreditCardType
    @Environment(\.dismiss) fileprivate var dismiss
    var body: some View {
        VStack(spacing: 0) {
            ForEach(cardTypes) { cardType in
                cardTypeView(cardType: cardType)
                    .onTapGesture {
                        selectedCardType = cardType
                        dismiss()
                    }
            }
            .padding(.top, Padding.medium)
        }
        .padding(.horizontal, Padding.default)
        .scrollable()
    }
    
    func cardTypeView(cardType type: CreditCardType) -> some View {
        HStack {
            type.icon
                .resizable(true)
                .frame(width: 32, height: 32)
                .padding(4)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.opaqueSeparator)
                        .foregroundColor(.systemBackground)
                )
            Text(type.name)
                .mont(.regular, size: 14)
            Spacer()
        }
        .background {
            Rectangle()
                .foregroundColor(.systemBackground.opacity(0.1))
        }
        .padding(.horizontal, Padding.small)
        .padding(.vertical, Padding.small)
        .modifier(YTextFieldBackgroundGrayStyle())
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Address Value
fileprivate struct AddressValue: Identifiable, Hashable {
    static func == (lhs: AddressValue, rhs: AddressValue) -> Bool {
        lhs.id == rhs.id
    }
    
    var region: (id: Int, name: String)
    var district: (id: Int, name: String)
    var street: String
    var homeNumber: String
    var phoneNumber: String
    var note: String
    
    var info: String {
        String("\(homeNumber), \(street), \(district.name), \(region.name)".prefix(32))
    }
    
    init(region: (id: Int, name: String), district: (id: Int, name: String), street: String, homeNumber: String, phoneNumber: String, note: String) {
        self.region = region
        self.district = district
        self.street = street
        self.homeNumber = homeNumber
        self.phoneNumber = phoneNumber
        self.note = note
    }
    
    init() {
        self.init(region: (id: -1, name: ""), district: (id: -1, name: ""), street: "", homeNumber: "", phoneNumber: "", note: "")
    }
    
    var id: String {
        info
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Insert Address View
fileprivate struct InsertAddressView: View {
    @Binding var address: AddressValue?
    @State private var region: (id: Int, name: String)?
    @State private var district: (id: Int, name: String)?

    @State private var street: String = ""
    @State private var home: String = ""
    @State private var phoneNumber: String = ""
    @State private var note: String = ""
    
    @State private var showRegions: Bool = false
    @State private var showDistricts: Bool = false
    
    @State private var isButtonEnabled: Bool = false
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack(spacing: 12) {
            
            SimpleRowButton(title: "region".localize, subtitle: region?.name ?? "select_region".localize, isPlaceholder: region?.name == nil)
                .onTapGesture {
                    showRegions = true
                }
            
            SimpleRowButton(title: "district".localize, subtitle: district?.name ?? "select_district".localize, isPlaceholder: district?.name == nil)
                .onTapGesture {
                    showDistricts = true
                }
            
            if district != nil {
                YTextField(text: $street, placeholder: "street".localize)
                    .frame(height: 50)
                    .padding(.horizontal, Padding.medium)
                    .modifier(YTextFieldBackgroundGrayStyle())
                
                YTextField(text: $home, placeholder: "home_address".localize)
                    .keyboardType(.numbersAndPunctuation)
                    .frame(height: 50)
                    .padding(.horizontal, Padding.medium)
                    .modifier(YTextFieldBackgroundGrayStyle())
                
                YTextField(text: $phoneNumber, placeholder: "phone_number".localize)
                    .set(format: "XX-XXX-XX-XX")
                    .keyboardType(.phonePad)
                    .frame(height: 50)
                    .padding(.horizontal, Padding.medium)
                    .modifier(YTextFieldBackgroundGrayStyle())
                
                TextView(text: $note, placeholder: "note".localize)
                    .multilineTextAlignment(.leading)
                    .mont(.regular, size: 14)
                    .frame(height: 150)
                    .lineLimit(7)
                    .modifier(YTextFieldBackgroundGrayStyle())
                    .dismissableKeyboard()
            }
            
            FlatButton(title: "next".localize) {
                onClickNext()
            }
            .padding(.horizontal, Padding.small)
            .disabled(!isButtonEnabled)
            .opacity(isButtonEnabled ? 1.0 : 0.3)
        }
        .scrollable()
        .navigationDestination(isPresented: $showRegions, destination: {
            SelectRegionView(selectedRegion: $region)
        })
        .navigationDestination(isPresented: $showDistricts, destination: {
            SelectDistrictView(regionId: region?.id ?? 0, selectedDistrict: $district)
        })
        .onChange(of: street, perform: { _ in
            updateButtonState()
        })
        .onChange(of: home, perform: { _ in
            updateButtonState()
        })
        .onChange(of: phoneNumber, perform: { _ in
            updateButtonState()
        })
        .onChange(of: note, perform: { _ in
            updateButtonState()
        })
        .padding()
        .onAppear {
            if let add = address {
                self.district = add.district
                self.region = add.region
                self.home = add.homeNumber
                self.phoneNumber = add.phoneNumber
                self.note = add.note
                self.street = add.street
            }
        }
    }
    
    private func updateButtonState() {
        guard region != nil && district != nil else {
            isButtonEnabled = false
            return
        }
        
        guard !home.isEmpty && !phoneNumber.isEmpty else {
            isButtonEnabled = false
            return
        }
        
        isButtonEnabled = true
    }
    
    private func onClickNext() {
        guard let region, let district else {
            return
        }
        
        guard !home.isEmpty && !phoneNumber.isEmpty else {
            return
        }
        
        address = .init(region: region,
                        district: district, street: street,
                        homeNumber: home,
                        phoneNumber: phoneNumber, note: note)
        
        dismiss()
    }
}

// MARK: - SelectRegionView
fileprivate struct SelectRegionView: View {
    @Binding var selectedRegion: (id: Int, name: String)?
    @Environment(\.dismiss) var dismiss
    @State private var regions: [(id: Int, name: String)] = []
    
    var body: some View {
        VStack {
            ForEach(regions, id: \.id) { region in
                HStack {
                    Text(region.name)
                    Spacer()
                }
                .mont(.regular, size: 14)
                .maxWidth(.infinity)
                .padding(Padding.small)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(Color(.secondarySystemBackground))
                        .frame(height: 40)
                }
                .onTapGesture {
                    selectedRegion = region
                    dismiss()
                }
                .padding(.horizontal, Padding.default)
                .padding(.vertical, Padding.small / 2)
            }
        }
        .navigationTitle("regions".localize)
        .scrollable()
        .onAppear {
            loadRegions()
        }
    }
    
    fileprivate func loadRegions() {
        Task(priority: .high) {
            let regions = await MainNetworkService.shared.getRegions()?.data ?? []
            await MainActor.run {
                self.regions = regions.map({($0.regionId, $0.regionName)})
            }
        }
    }
}

// MARK: - SelectDistrictView
fileprivate struct SelectDistrictView: View {
    var regionId: Int
    @Binding var selectedDistrict: (id: Int, name: String)?
    @Environment(\.dismiss) var dismiss
    @State private var districts: [(id: Int, name: String)] = []
    
    var body: some View {
        VStack {
            ForEach(districts, id: \.id) { region in
                HStack {
                    Text(region.name)
                        .font(.mont(.regular, size: 14))
                    Spacer()
                }
                .mont(.regular, size: 14)
                .maxWidth(.infinity)
                .padding(Padding.small)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(Color(.secondarySystemBackground))
                        .frame(height: 40)
                }
                .onTapGesture {
                    selectedDistrict = region
                    dismiss()
                }
                .padding(.horizontal, Padding.default)
                .padding(.vertical, Padding.small / 2)
            }
        }
        .navigationTitle("regions".localize)
        .scrollable()
        .onAppear {
            loadDistricts()
        }
    }
    
    fileprivate func loadDistricts() {
        
        Task(priority: .high) {
            let districts = await MainNetworkService.shared.getDistricts(regionId)?.data ?? []
            DispatchQueue.main.async {
                self.districts = districts.map({($0.districtId, $0.districtName)})
            }
        }
    }
}
