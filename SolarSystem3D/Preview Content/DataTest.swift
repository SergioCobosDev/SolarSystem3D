//
//  DataTest.swift
//  SolarSystem3D
//
//  Created by Julio César Fernández Muñoz on 15/7/24.
//

import SwiftUI

struct DataTest: DataInteractor {
    var url: URL { Bundle.main.url(forResource: "SolarSystemTest", withExtension: "json")! }
}

extension ContentView {
    static var preview: some View {
        ContentView()
            .environment(PlanetsViewModel(interactor: DataTest()))
    }
}

extension PlanetModel {
    static let test = PlanetModel(id: UUID(),
                                  name: "Tierra",
                                  diameterKm: 12742,
                                  averageTemperatureCelsius: 15,
                                  waterPercentage: 71,
                                  numberOfSatellites: 1,
                                  satellites: ["Luna"], 
                                  distanceFromSunKm: 149600000,
                                  orbitalPeriodDays: 365.25,
                                  rotationPeriodHours: 24,
                                  atmosphereComposition: [
                                    AtmosphereComposition(element: "nitrogen", percentage: 78),
                                    AtmosphereComposition(element: "oxygen", percentage: 21),
                                    AtmosphereComposition(element: "other", percentage: 1)
                                  ],
                                  description: "La Tierra es el tercer planeta del sistema solar y el único conocido que alberga vida. Tiene una superficie cubierta en su mayoría por agua y una atmósfera rica en oxígeno. La Tierra posee un satélite natural, la Luna, que influye en las mareas y en diversos aspectos del clima y la vida en el planeta.",
                                  scale: 0.009157682909299986,
                                  positionZ: 6.66,
                                  model3d: "Earth")
}
