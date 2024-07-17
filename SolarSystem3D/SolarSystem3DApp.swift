//
//  SolarSystem3DApp.swift
//  SolarSystem3D
//
//  Created by Julio César Fernández Muñoz on 15/7/24.
//

import SwiftUI

@main
struct SolarSystem3DApp: App {
    @State var planetsVM = PlanetsViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(planetsVM)
        }
        
        WindowGroup(id: "planetDetail") {
            VolumetricPlanet()
                .environment(planetsVM)
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 1.0, height: 1.0, depth: 1.0, in: .meters)
    }
}
