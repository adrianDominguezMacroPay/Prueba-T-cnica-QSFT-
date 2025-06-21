//
//  LocationServiceDelegate.swift
//  PruebaTécnicaQSFT
//
//  Created by Adrian Pascual Dominguez Gomez on 21/06/25.
//

import CoreLocation

protocol LocationServiceDelegate: AnyObject {
    func didUpdateLocation(latitude: Double, longitude: Double)
    func didFailWithError(error: Error)
    
}

final class LocationService: NSObject {
    private let locationManager = CLLocationManager()
    weak var delegate: LocationServiceDelegate?

    override init() {
        super.init()
        locationManager.delegate = self
        
    }
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        
    }
    func requestLocation() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        default:
            delegate?.didFailWithError(
                error: NSError(domain: "Location", code: 1, userInfo: [NSLocalizedDescriptionKey: "Permiso denegado"]))
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.first else { return }
        delegate?.didUpdateLocation(latitude: loc.coordinate.latitude,
                                    longitude: loc.coordinate.longitude)
        stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.didFailWithError(error: error)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.requestLocation()
        }
    }
}
