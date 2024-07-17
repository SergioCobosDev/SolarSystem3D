//
//  VolumetricPlanet.swift
//  SolarSystem3D
//
//  Created by Julio César Fernández Muñoz on 17/7/24.
//

import SwiftUI
import RealityKit
import SolarSystemPlanets

struct VolumetricPlanet: View {
    @Environment(PlanetsViewModel.self) private var planetsVM
    
    var body: some View {
        ZStack {
            
            RealityView { content in
                guard let selectedPlanet = planetsVM.selectedPlanet else {
                    print("No hay nada")
                     return
                }
                do {
                    let planet = try await Entity(named: "\(selectedPlanet.model3d)Scene", in: solarSystemPlanetsBundle)
                    content.add(planet)
                } catch {
                    print("Error en la carga \(error)")
                }
            }
        }
    }
}

#Preview(windowStyle: .volumetric) {
    let vm = PlanetsViewModel(interactor: DataTest())
    VolumetricPlanet()
        .frame(depth: 1.0)
        .frame(width: 1.0, height: 1.0)
        .environment(vm)
        .onAppear {
            vm.selectedPlanet = vm.planets.first
        }
}
