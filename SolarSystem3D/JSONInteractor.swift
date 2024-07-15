//
//  JSONInteractor.swift
//  SolarSystem3D
//
//  Created by Julio César Fernández Muñoz on 15/7/24.
//

import Foundation

protocol JSONInteractor {
    func loadJSON<JSON>(url: URL, type: JSON.Type) throws -> JSON where JSON: Codable
}

extension JSONInteractor {
    func loadJSON<JSON>(url: URL, type: JSON.Type) throws -> JSON where JSON: Codable {
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(type, from: data)
    }
}
