//
//  LocationListPresenterProtocol.swift
//  PruebaTécnicaQSFT
//
//  Created by Adrian Pascual Dominguez Gomez on 21/06/25.
//


import Foundation

//comunicacion para el interactor
protocol LocationListPresenterProtocol: AnyObject {
    func didLoadLocations(_ locations: [LocationEntity])
    func didFailAddingLocation(error: Error)
}


//comunicacion para la vista
protocol LocationListViewProtocol: AnyObject {
    func showLocations(_ viewModels: [LocationCellViewModel])
    func showError(message: String)
    func showLoader()
    func hideLoader()
}


class LocationListPresenter {
    weak var view: LocationListViewProtocol?
    var interactor: LocationListInteractorProtocol?

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return formatter
    }()
    
    
    func viewDidLoad() {
        view?.showLoader()
        interactor?.loadLocations()
    }

    func didTapAddLocation() {
        view?.showLoader()
        interactor?.addLocation()
    }

    func didSelectRow(with id: Int) {
        view?.showLoader()
        interactor?.incrementCounter(for: id)
    }

    func didTapDelete(id: Int) {
        view?.showLoader()
        interactor?.deleteLocation(id: id)
    }
    
    func didTapAddManualLocation(lat: Double, lon: Double) {
        view?.showLoader()
        interactor?.insertManualLocation(lat: lat, lon: lon)
    }
}


//Aqui se convierte el DTO o un ViewModel adaptado para la vista
extension LocationListPresenter: LocationListPresenterProtocol {
    func didLoadLocations(_ locations: [LocationEntity]) {
        let viewModels = locations.map { location in
            LocationCellViewModel(
                id: location.id,
                counterText: "Contador: \(location.counter)",
                formattedDate: dateFormatter.string(from: location.modifiedAt),
                latitude: location.latitude,
                longitude: location.longitude
            )
        }
        view?.hideLoader()
        view?.showLocations(viewModels)
    }

    func didFailAddingLocation(error: Error) {
        view?.showError(message: error.localizedDescription)
    }
}

