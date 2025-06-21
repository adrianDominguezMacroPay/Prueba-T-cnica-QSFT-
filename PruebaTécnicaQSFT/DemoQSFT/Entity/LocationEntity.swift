//
//  LocationEntity.swift
//  PruebaTécnicaQSFT
//
//  Created by Adrian Pascual Dominguez Gomez on 21/06/25.
//

import Foundation

struct LocationEntity {
    let id: Int
    let latitude: Double
    let longitude: Double
    var counter: Int
    let modifiedAt: Date
}


struct LocationCellViewModel {
    let id: Int
    let counterText: String
    let formattedDate: String
}
