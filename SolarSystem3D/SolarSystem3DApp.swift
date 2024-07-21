import SwiftUI

@main
struct SolarSystem3DApp: App {
    @State var planetsVM = PlanetsViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(planetsVM)
        }
        .windowResizability(.contentSize)
        
        WindowGroup(id: "planetDetail") {
            VolumetricPlanet()
                .environment(planetsVM)
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 0.5, height: 0.5, depth: 0.5, in: .meters)
    }
}
