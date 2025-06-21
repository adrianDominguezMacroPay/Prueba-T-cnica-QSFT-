//
//  LocationListInteractorProtocol.swift
//  PruebaTécnicaQSFT
//
//  Created by Adrian Pascual Dominguez Gomez on 21/06/25.
//

import Foundation

protocol LocationListInteractorProtocol: AnyObject {
    func loadLocations()
    func addLocation()
    func incrementCounter(for id: Int)
    func deleteLocation(id: Int)
    func insertManualLocation(lat: Double, lon: Double)
}



final class LocationListInteractor {
    weak var presenter: LocationListPresenterProtocol?
     let locationService = LocationService()
    
    init() {
        locationService.delegate = self
    }
}

extension LocationListInteractor: LocationListInteractorProtocol {
    
    func loadLocations() {
        SQLiteManager.shared.fetchLocations { [weak self] locations in
            self?.presenter?.didLoadLocations(locations)
        }
    }


    func addLocation() {
        locationService.requestLocation() // Esto disparará didUpdateLocation o didFail
    }

    func incrementCounter(for id: Int) {
        SQLiteManager.shared.updateCounter(forID: id) { [weak self] in
            self?.loadLocations()
        }
    }

    func deleteLocation(id: Int) {
        SQLiteManager.shared.deleteLocation(id: id) { [weak self] in
            self?.loadLocations()
        }
    }
    func insertManualLocation(lat: Double, lon: Double) {
        SQLiteManager.shared.insertLocation(latitude: lat, longitude: lon) { [weak self] in
            self?.loadLocations()
        }
    }
}



//el delegado de LocationServides
extension LocationListInteractor: LocationServiceDelegate {
    func didUpdateLocation(latitude: Double, longitude: Double) {
        SQLiteManager.shared.insertLocation(latitude: latitude, longitude: longitude) { [weak self] in
            
            self?.loadLocations()
            self?.locationService.stopUpdatingLocation()
        }
    }

    func didFailWithError(error: Error) {
        print("Error al obtener la ubicación: \(error.localizedDescription)")
        presenter?.didFailAddingLocation(error: error)
    }
}
