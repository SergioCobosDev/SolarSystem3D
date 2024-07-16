//
//  ContentView.swift
//  SolarSystem3D
//
//  Created by Julio César Fernández Muñoz on 15/7/24.
//

import SwiftUI
import RealityKit
import SolarSystemPlanets

struct ContentView: View {
    @State var planetsVM = PlanetsViewModel()
    @State private var selectedPlanet: PlanetModel?
    @State private var rotationAngle: Double = 0.0
    
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
            if let selectedPlanet {
                Model3D(named: selectedPlanet.model3d,
                        bundle: solarSystemPlanetsBundle) { model in
                    model
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(0.7)
                        .rotation3DEffect(.degrees(rotationAngle),
                                          axis: (x: 0, y: -1, z: 0))
                } placeholder: {
                    ProgressView()
                }
            }
        }
        .onAppear {
            doRotation()
        }
        .alert("App Error",
               isPresented: $planetsVM.showAlert) {} message: {
            Text(planetsVM.errorMsg)
        }
    }
    
    func doRotation() {
        Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { _ in
            let angle = rotationAngle + 0.2
            rotationAngle = rotationAngle < 360 ? angle : 0
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView.preview
}
