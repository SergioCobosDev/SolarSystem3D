//
//  PlanetDetail.swift
//  SolarSystem3D
//
//  Created by Julio César Fernández Muñoz on 15/7/24.
//

import SwiftUI

struct PlanetDetail: View {
    let selectedPlanet: PlanetModel
    
    var body: some View {
        Form {
            LabeledContent("**Diameter in Km**", value: "\(selectedPlanet.diameterKm)")
            LabeledContent("**Average Temperature**", value: "\(selectedPlanet.averageTemperatureCelsius)")
            LabeledContent("**Water Percentage**", value: "\(selectedPlanet.waterPercentage)")
            if selectedPlanet.numberOfSatellites > 0 {
                LabeledContent("**Number of Satellites**", value: "\(selectedPlanet.numberOfSatellites)")
                LabeledContent("**Satellites**", value: selectedPlanet.satellites.formatted(.list(type: .and)))
            }
        }
        .navigationTitle(selectedPlanet.name)
    }
}

#Preview(windowStyle: .automatic) {
    PlanetDetail(selectedPlanet: .test)
}
