import SwiftUI
import RealityKit
import SolarSystemPlanets
import Combine

struct VolumetricPlanet: View {
    @Environment(PlanetsViewModel.self) private var planetsVM
    let rotationTimer = Timer.publish(every: 0.03, on: .main, in: .common).autoconnect()
    @Environment(\.dismissWindow) private var dismissWindow

    @State private var subs = Set<AnyCancellable>()
    
    var body: some View {
        RealityView { content, attachments in
            guard let selectedPlanet = planetsVM.selectedPlanet else {
                print("No hay nada")
                 return
            }
            do {
                let scene = try await Entity(named: "\(selectedPlanet.model3d)Scene", in: solarSystemPlanetsBundle)
                content.add(scene)
                
                let earthOrbit = Entity()
                scene.addChild(earthOrbit)
                
                if let menu = attachments.entity(for: "menu") {
                    content.add(menu)
                    menu.setPosition([0, -0.1, 0.2], relativeTo: scene)
                }
                
                if let earthInfo = attachments.entity(for: "earthInfo"),
                   let earth = scene.findEntity(named: "Earth"),
                   let sun = scene.findEntity(named: "Sun") {
                    sun.setPosition([0,0,0], relativeTo: scene)
                    earthOrbit.transform = earth.transform
                    earthOrbit.addChild(earth, preservingWorldTransform: true)
                    earthOrbit.addChild(earthInfo, preservingWorldTransform: true)
                    earthInfo.setPosition([0, 0.2, 0.0], relativeTo: earth)
                    try? orbitAnimation(for: earthOrbit)
                    rotationTimer.sink { _ in
                        sun.transform.rotation *= simd_quatf(angle: Float(0.005), axis: [0, 1, 0])
                        earth.transform.rotation *= simd_quatf(angle: Float(0.02), axis: [0, 1, 0])
                    }
                    .store(in: &subs)
                }
            } catch {
                print("Error en la carga \(error)")
            }
        } attachments: {
            Attachment(id: "earthInfo") {
                VStack {
                    Text("Earth")
                }
                .padding()
                .glassBackgroundEffect()
            }
            Attachment(id: "menu") {
                if let selected = planetsVM.selectedPlanet {
                    HStack(spacing: 40) {
                        Text(selected.name)
                        Button {
                            dismissWindow()
                        } label: {
                            Image(systemName: "xmark")
                                .symbolVariant(.fill)
                        }
                    }
                    .padding()
                    .glassBackgroundEffect()
                }
            }
        }
        .onDisappear {
            planetsVM.showingPlanet = false
        }
    }
    
    func orbitAnimation(for entity: Entity) throws {
        let radius: Float = 0.2
        let duration = 30.0
        
        let startTransform = Transform(
            scale: entity.scale,
            rotation: simd_quatf(angle: 0,
                                 axis: [0, 1, 0]),
            translation: [radius, 0, 0]
        )
        
        let orbitAnimation = OrbitAnimation(
            duration: duration,
            axis: [
                0,
                1,
                0
            ],
            startTransform: startTransform,
            orientToPath: false,
            bindTarget: .transform
        )
        
        let animation = try AnimationResource.generate(with: orbitAnimation)
        entity.playAnimation(animation.repeat())
    }
}

#Preview(windowStyle: .volumetric) {
    let vm = PlanetsViewModel(interactor: DataTest())
    VolumetricPlanet()
        .environment(vm)
        .onAppear {
            vm.selectedPlanet = vm.planets.first
        }
}
