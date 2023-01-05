//
//  LocationManager.swift
//  YuzPay
//
//  Created by applebro on 03/01/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()

    var location: CLLocationCoordinate2D?

    var onLocationUpdate: (() -> Void)?
    
    static let shared = LocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.pausesLocationUpdatesAutomatically = true
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocation() {
        DispatchQueue.global(qos: .background).async {
            self.manager.requestWhenInUseAuthorization()
            self.manager.requestLocation()
            self.manager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.first?.coordinate
        
        if let loc = location {
            Logging.l("New location \(loc)")
        }
        
        self.onLocationUpdate?()
        self.manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Logging.l("Cannot get location \(error.localizedDescription)")
    }
}

