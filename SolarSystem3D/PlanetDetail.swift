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
            Section {
                Text(selectedPlanet.description)
            } header: {
                Text("Descripción")
            }
            
            Section {
                LabeledContent("**Diámetro en Km.**", value: "\(selectedPlanet.diameterKm)")
                LabeledContent("**Temperatura Media**", value: "\(selectedPlanet.averageTemperatureCelsius)")
                LabeledContent("**Porcentaje de Agua**", value: "\(selectedPlanet.waterPercentage)")
                LabeledContent("**Tiempo de orbitación (en días)**", value: "\(selectedPlanet.orbitalPeriodDays)")
                LabeledContent("**Tiempo de rotación (en horas)**", value: "\(selectedPlanet.rotationPeriodHours)")
                LabeledContent("**Distancia al Sol**", value: "\(selectedPlanet.distanceFromSunKm)")
                if selectedPlanet.numberOfSatellites > 0 {
                    LabeledContent("**Número de satélites**", value: "\(selectedPlanet.numberOfSatellites)")
                    LabeledContent("**Satélites**", value: selectedPlanet.satellites.formatted(.list(type: .and)))
                }
            } header: {
                Text("Datos Planetarios")
            }
            
            Section {
                ForEach(selectedPlanet.atmosphereComposition) { comp in
                    Text(comp.elementDesc)
                }
            } header: {
                Text("Composición")
            }
        }
        .navigationTitle(selectedPlanet.name)
    }
}

#Preview {
    NavigationStack {
        PlanetDetail(selectedPlanet: .test)
    }
    .frame(width: 400)
}
