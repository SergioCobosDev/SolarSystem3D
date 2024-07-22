import SwiftUI
import RealityKit
import SolarSystemPlanets

struct ContentView: View {
    @Environment(PlanetsViewModel.self) private var planetsVM
    @Environment(\.openWindow) private var open
    
    @State private var rotationAngle: CGFloat = 0.0
    
    @State private var rotate = true
    @State private var touch = false
    
    @State private var currentRotation: CGFloat = 0.0
    @State private var lastDragValue: CGFloat = 0.0
    @State private var velocity: CGFloat = 0.0
    
    @State var initialScale: CGFloat = 1.0
    @State private var scaleMagnified: Double = 1.0
    
    let retrogradePlanets = ["Venus", "Urano"]
    
    let maxScalePlanets = 0.71
    let minScalePlanets = 0.3
    let scaleFactorPlanets = 50.0
    
    var body: some View {
        @Bindable var planetBindable = planetsVM
        NavigationSplitView {
            List(selection: $planetBindable.selectedPlanet) {
                ForEach(planetsVM.planets) { planet in
                    Text(planet.name)
                        .tag(planet)
                }
            }
            .navigationTitle("Planets")
            .navigationSplitViewColumnWidth(200)
            .toolbar {
                ToolbarItem(placement: .bottomOrnament) {
                    HStack(spacing: 30) {
                        Toggle(isOn: $rotate) {
                            Image(systemName: "rotate.3d")
                        }
                        .disabled(touch)
                        if let selectedPlanet = planetsVM.selectedPlanet {
                            Text(selectedPlanet.name)
                                .frame(width: 100)
                                .padding(10)
                                .glassBackgroundEffect()
                        }
                        Toggle(isOn: $touch) {
                            Image(systemName: "hand.point.up.left")
                        }
                        .disabled(rotate)
                        Button {
                            planetsVM.showingPlanet = true
                            open(id: "planetDetail")
                        } label: {
                            Text("Ver en Detalle")
                        }
                        .disabled(planetsVM.showingPlanet)
                    }
                    .toggleStyle(.button)
                }
            }
        } content: {
            if let selectedPlanet = planetsVM.selectedPlanet {
                PlanetDetail(selectedPlanet: selectedPlanet)
            }
        } detail: {
            if let selectedPlanet = planetsVM.selectedPlanet {
                Model3D(named: selectedPlanet.model3d,
                        bundle: solarSystemPlanetsBundle) { model in
                    model
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(scaleMagnified)
                        .scaleEffect(adjustedScaleForPlanet(named: selectedPlanet.name, originalScale: selectedPlanet.scale))
                        .offset(y: -50)
                        .rotation3DEffect(.degrees(selectedPlanet.name == "Urano" ? 90 : rotationAngle), axis: selectedPlanet.name == "Urano" ? (x: 0, y: 0, z: 0) : (x: 0, y: -1, z: 0))
                        .rotation3DEffect(.degrees(selectedPlanet.name == "Urano" ? rotationAngle : 0), axis: (x: 0, y: 0, z: 1))
                        .rotation3DEffect(.degrees(Double(currentRotation)), axis: (x: 0, y: 1, z: 0))
                } placeholder: {
                    ProgressView()
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let delta = value.translation.width - lastDragValue
                            velocity = delta / 10
                            lastDragValue = value.translation.width
                            if touch {
                                currentRotation += velocity
                            }
                        }
                        .onEnded { _ in
                            lastDragValue = 0.0
                            if touch {
                                startInertia()
                            }
                        }
                )
                .gesture(
                    MagnifyGesture()
                        .onChanged { value in
                            let newScale = (1.0 - (value.magnification)) + initialScale
                            if newScale > 0.4 && newScale < 1.0 {
                                scaleMagnified = newScale
                            }
                        }
                        .onEnded { value in
                            initialScale = scaleMagnified
                        }
                )
            }
        }
        .onAppear {
            doRotation()
            planetsVM.selectedPlanet = planetsVM.planets.first
        }
        .alert("App Error",
               isPresented: $planetBindable.showAlert) {} message: {
            Text(planetsVM.errorMsg)
        }
    }
    
    func doRotation() {
        let timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { _ in
            var angle = rotationAngle - 0.2
            if let selectedPlanet = planetsVM.selectedPlanet {
                if retrogradePlanets.contains(selectedPlanet.name) {
                    angle = rotationAngle + 0.2
                } else {
                    angle = rotationAngle - 0.2
                }
            } else {
                angle = rotationAngle - 0.2
            }
            if rotate {
                rotationAngle = rotationAngle < 360 ? angle : 0
            }
        }
        RunLoop.current.add(timer, forMode: .common)
    }
        
    func startInertia() {
        let inertialTimer =  Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { timer in
            if abs(velocity) < 0.01 {
                timer.invalidate()
            } else {
                velocity *= 0.95
                currentRotation += velocity
            }
        }
        RunLoop.current.add(inertialTimer, forMode: .common)
    }
    
    func adjustedScaleForPlanet(named name: String, originalScale: Double) -> CGFloat {
        if name == "Sol" {
            return maxScalePlanets
        } else {
            let scaledValue = CGFloat(originalScale) * scaleFactorPlanets
            return min(max(scaledValue, minScalePlanets), maxScalePlanets * 0.8)
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView.preview
}
