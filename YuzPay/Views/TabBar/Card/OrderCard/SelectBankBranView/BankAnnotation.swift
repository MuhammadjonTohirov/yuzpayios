//
//  BankAnnotationView.swift
//  YuzPay
//
//  Created by applebro on 03/01/23.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit

class BankAnnotation: NSObject, MKAnnotation, Identifiable {
    var id: String = UUID().uuidString
    
    var coordinate: CLLocationCoordinate2D
    
    var title: String?
    
    var subtitle: String?
    
    var workingHoursDetails: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, address: String, workingHours: String?) {
        self.coordinate = coordinate
        self.id = "\(coordinate.latitude)_\(coordinate.longitude)"
        self.title = title
        self.subtitle = address
        self.workingHoursDetails = workingHours
    }
}

struct BankInfoItem {
    var title: String
    var address: String
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
