//
//  ContentView.swift
//  SolarSystem3D
//
//  Created by Julio César Fernández Muñoz on 15/7/24.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    @State var planetsVM = PlanetsViewModel()
    
    @State private var selectedPlanet: PlanetModel?
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedPlanet) {
                ForEach(planetsVM.planets) { planet in
                    Text(planet.name)
                        .tag(planet)
                }
            }
            .navigationTitle("Planets")
            .navigationSplitViewColumnWidth(200)
        } content: {
            if let selectedPlanet {
                PlanetDetail(selectedPlanet: selectedPlanet)
            } else {
                Text("Select a planet from the list.")
            }
        } detail: {
            
        }
        .alert("App Error",
               isPresented: $planetsVM.showAlert) {} message: {
            Text(planetsVM.errorMsg)
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView.preview
}
