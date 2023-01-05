//
//  MapView.swift
//  YuzPay
//
//  Created by applebro on 03/01/23.
//

import Foundation
import CoreLocation
import UIKit
import SwiftUIX
import MapKit
import SwiftUI

final class MapView: UIView {
    let mapView = MKMapView.init()
    
    var annotationViewFor: ((_ annotation: MKAnnotation) -> AnyView)?
    var annotationDidSelect: ((_ annotation: MKAnnotation) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(mapView)
        mapView.delegate = self
        mapView.userTrackingMode = .followWithHeading
        mapView.isPitchEnabled = true
        mapView.isScrollEnabled = true
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: "bank_annotation")
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.mapView.frame = self.bounds
    }

    func add(annotation: MKAnnotation) {
        if self.mapView.annotations.contains(where: {$0.isEqual(annotation)}) {
            self.mapView.removeAnnotation(annotation)
        }
        
        self.mapView.addAnnotation(annotation)
    }
    
    func setRegion(_ region: MKCoordinateRegion, animated: Bool = false) {
        self.mapView.setRegion(region, animated: animated)
    }
    
    func setCoordinate(_ coordinate: CLLocationCoordinate2D, latMeters: CLLocationDistance = 500, lonMeters: CLLocationDistance = 500, animated: Bool = false) {
        self.mapView.setRegion(.init(center: coordinate, latitudinalMeters: latMeters, longitudinalMeters: lonMeters), animated: animated)
    }
    
    fileprivate var selectedAnnotation: MKAnnotation?
}

extension MapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if self.mapView.userLocation.location?.coordinate != annotation.coordinate, let view = self.annotationViewFor?(annotation) {
            let annotView = mapView.dequeueReusableAnnotationView(withIdentifier: "bank_annotation", for: annotation)
            annotView.frame.size = .init(width: 40, height: 40)
            annotView.canShowCallout = true
            annotView.rightCalloutAccessoryView = UIImageView(image: UIImage(systemName: "info.circle"))
            
            let v = UIHostingView(rootView: view)
            v.center = annotView.center
            annotView.addSubview(v)
            annotView.rightCalloutAccessoryView?.onClick(self, #selector(onClickAnnotationInfo))
            return annotView
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        selectedAnnotation = annotation
    }
    
    func mapView(_ mapView: MKMapView, didDeselect annotation: MKAnnotation) {
        selectedAnnotation = nil
    }
    
    @objc private func onClickAnnotationInfo() {
        if let sann = self.selectedAnnotation {
            self.annotationDidSelect?(sann)
        }
    }
}

struct YMapView<Annotation: MKAnnotation>: UIViewRepresentable {
    
    @Binding var annotations: [Annotation]
    @Binding var currentLocation: CLLocationCoordinate2D
    
    var annotationView: ((MKAnnotation) -> AnyView)?
    var annotationSelect: ((MKAnnotation) -> Void)?
    
    func makeUIView(context: Context) -> MapView {
        let map = MapView()
        map.annotationViewFor = annotationView
        map.annotationDidSelect = annotationSelect
        return map
    }
    
    func updateUIView(_ uiView: MapView, context: Context) {
        Logging.l("Number of annotations \(annotations.count)")
        annotations.forEach { an in
            uiView.add(annotation: an)
        }
        
        uiView.setCoordinate(currentLocation)
    }
    
    typealias UIViewType = MapView
}
