//
//  SelectBankBranchView.swift
//  YuzPay
//
//  Created by applebro on 03/01/23.
//

import SwiftUI
import CoreLocation
import MapKit

struct SelectBankBranchView: View {
    @State private var annotations: [BankAnnotation] = []
    @State private var coordinate: CLLocationCoordinate2D = .init()
    @State var isShowingList = false
    @State var showReceipt = false
    @EnvironmentObject var viewModel: OrderCardViewModel
    var body: some View {
        innerBody
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("order_card".localize)
    }
    
    var innerBody: some View {
        ZStack {
            NavigationLink("", isActive: $showReceipt) {
                OrderCardReceiptView()
                    .environmentObject(viewModel)
            }
            
            YMapView(annotations: $annotations, currentLocation: $coordinate, annotationView:  { annotation in
                AnyView (
                    Image("icon_bank_annotation")
                        .resizable(resizingMode: .stretch)
                        .frame(width: 32, height: 32)
                        .background(
                            Circle()
                                .frame(width: 38, height: 38)
                                .foregroundColor(.init(uiColor: .systemBackground).opacity(0.5))
                        )
                )
            }, annotationSelect: { annotation in
                if let ann = annotation as? BankAnnotation {
                    debugPrint(ann.title ?? "")
                    showReceipt = true
                }
            })
            .ignoresSafeArea()
            
            VStack(alignment: .trailing) {
                Spacer()
                    .maxWidth(.infinity)
                
                Button {
                    coordinate = LocationManager.shared.location ?? coordinate
                } label: {
                    Image(systemName: "location.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40, alignment: .bottomTrailing)
                        .padding(Padding.large)
                }

            }

            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("select_branch".localize)
                        .mont(.semibold, size: 28)
                        .maxWidth(200)
                    Spacer()
                    
                    Button {
                        withAnimation {
                            isShowingList.toggle()
                        }
                    } label: {
                        Label {
                            Text(isShowingList ? "from_map".localize : "from_list".localize)
                        } icon: {
                            Image(systemName: isShowingList ? "list.bullet" : "map")
                        }
                    }

                }
                .padding(.horizontal, Padding.default)
                .padding(.bottom, Padding.medium)
                .background(Color.systemBackground)
                
                if isShowingList && !annotations.isEmpty {
                    branchList
                        .transition(.opacity)
                        .background(Color.systemBackground.opacity(0.5))
                } else {
                    Spacer()
                }
            }
        }
        .onAppear {
            LocationManager.shared.onLocationUpdate = {
                onSetCurrentLocation()
            }
            LocationManager.shared.requestLocation()
        }
    }
    
    private var branchList: some View {
        List {
            ForEach(annotations) { bankItem in
                HStack(spacing: Padding.medium) {
                    Image("icon_mappin")
                        .resizable()
                        .frame(width: 20, height: 20)
                    
                    VStack(alignment: .leading) {
                        Text(bankItem.title ?? "")
                            .mont(.semibold, size: 14)
                        
                        Text(bankItem.subtitle ?? "")
                            .mont(.medium, size: 10)
                        
                        Text(bankItem.workingHoursDetails ?? "")
                            .mont(.medium, size: 10)
                    }
                    .onTapGesture {
                        showReceipt = true
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation {
                            isShowingList.toggle()
                            self.coordinate = bankItem.coordinate
                        }
                    } label: {
                        Text("in_map".localize)
                    }
                    .padding(.leading, Padding.medium)
                }.background(Rectangle().foregroundColor(.clear).onTapGesture {
                    showReceipt = true
                })
            }
            .listRowSeparator(.visible, edges: .bottom)
        }
        .listStyle(.plain)

    }
    
    private func onSetCurrentLocation() {
        DispatchQueue.main.async {
            if coordinate == .init() {
                coordinate = LocationManager.shared.location ?? coordinate
             
                annotations.append(BankAnnotation(
                    coordinate: .init(latitude: coordinate.latitude - 0.005, longitude: coordinate.longitude - 0.004),
                    title: "Головной Офис АКБ \"Капиталбанк\"",
                    address: "Юнусабадский р-н, ул. Сайилгох, д. 7",
                    workingHours: "пн-пт — 9:00-17:00; обед — 13:00-14:00"
                ))
            }
        }
    }
}

struct SelectBankBranchView_Previews: PreviewProvider {
    static var previews: some View {
        SelectBankBranchView()
    }
}
