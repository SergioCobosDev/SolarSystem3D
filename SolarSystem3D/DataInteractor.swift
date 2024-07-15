//
//  DataInteractor.swift
//  SolarSystem3D
//
//  Created by Julio César Fernández Muñoz on 15/7/24.
//

import Foundation

protocol DataInteractor: JSONInteractor {
    var url: URL { get }
    func getPlanets() throws -> [PlanetModel]
}

extension DataInteractor {
    var url: URL { Bundle.main.url(forResource: "SolarSystem", withExtension: "json")! }
    
    func getPlanets() throws -> [PlanetModel] {
        try loadJSON(url: url, type: [PlanetDTO].self).sorted { p1, p2 in
            p1.order < p2.order
        }.map(\.toPresentation)
    }
}

struct Interactor: DataInteractor {}
