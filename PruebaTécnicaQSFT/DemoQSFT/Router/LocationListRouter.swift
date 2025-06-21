//
//  LocationListRouter.swift
//  PruebaTécnicaQSFT
//
//  Created by Adrian Pascual Dominguez Gomez on 21/06/25.
//

import UIKit

final class LocationListRouter {
    static func createModule() -> UIViewController {
        let view = LocationListViewController()
        let presenter = LocationListPresenter()
        let interactor = LocationListInteractor()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        interactor.presenter = presenter

        return UINavigationController(rootViewController: view)
    }
}
