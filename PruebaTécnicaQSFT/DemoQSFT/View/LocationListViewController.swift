//
//  LocationListViewController.swift
//  PruebaTécnicaQSFT
//
//  Created by Adrian Pascual Dominguez Gomez on 21/06/25.
//

import UIKit

class LocationListViewController: UITableViewController {
    var presenter: LocationListPresenter?
    private let loader = UIActivityIndicatorView(style: .large)
    private var locations: [LocationCellViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Ubicaciones"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addLocationTapped))
        let manualAddButton = UIBarButtonItem(title: "Manual", style: .plain, target: self, action: #selector(addManualLocationTapped))
        navigationItem.leftBarButtonItem = manualAddButton
        
        loader.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loader)
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        presenter?.viewDidLoad()
    }
    @objc func addLocationTapped() {
        presenter?.didTapAddLocation()
    }
    
    
    
    func reload(with viewModels: [LocationCellViewModel]) {
        
        self.locations = viewModels
        tableView.reloadData()
    }
    
    
    //delegado de las tablas
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = locations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        var config = cell.defaultContentConfiguration()
        config.text = vm.counterText
        let locationDetail = "Lat: \(vm.latitude), Lon: \(vm.longitude)"
        config.secondaryTextProperties.numberOfLines = 2
        config.secondaryText = "\(vm.formattedDate)\n\(locationDetail)"
        cell.contentConfiguration = config

        // Botón de eliminar
        let deleteButton = UIButton(type: .close)
        deleteButton.tag = vm.id
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
        cell.accessoryView = deleteButton

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = locations[indexPath.row].id
        presenter?.didSelectRow(with: id)
    }
    
    @objc private func deleteButtonTapped(_ sender: UIButton) {
        let id = sender.tag
        presenter?.didTapDelete(id: id)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Ocurrio un Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    func showLoader() {
        loader.startAnimating()
        view.isUserInteractionEnabled = false
    }

    func hideLoader() {
        loader.stopAnimating()
        view.isUserInteractionEnabled = true
    }
    @objc func addManualLocationTapped() {
        let alert = UIAlertController(title: "Agregar ubicación manual", message: "Ingresa latitud y longitud", preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Latitud (e.g. 19.4326)" }
        alert.addTextField { $0.placeholder = "Longitud (e.g. -99.1332)" }
        
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
       
        alert.addAction(UIAlertAction(title: "Agregar", style: .default, handler: { [weak self] _ in
            guard let latText = alert.textFields?[0].text,
                  let lonText = alert.textFields?[1].text,
                  let lat = Double(latText),
                  let lon = Double(lonText) else {
                self?.showAlert(message: "Coordenadas inválidas")
                return
            }
            self?.presenter?.didTapAddManualLocation(lat: lat, lon: lon)
        }))
        self.present(alert, animated: true)
    }

}


//Implementacion de protocolo
extension LocationListViewController: LocationListViewProtocol {
    func showLocations(_ viewModels: [LocationCellViewModel]) {
        reload(with: viewModels)
    }

    func showError(message: String) {
        showAlert(message: message)
    }
}

    
