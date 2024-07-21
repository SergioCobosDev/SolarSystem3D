import SwiftUI
import RealityKit

struct TestRealityView: View {
    @State private var touch = false
    @State private var subscription: EventSubscription?
    
    var body: some View {
        RealityView { content in
            let sphereMesh = MeshResource.generateSphere(radius: 0.2)
            let sphereMaterial = SimpleMaterial(color: .green, isMetallic: false)
            let sphere = ModelEntity(mesh: sphereMesh, materials: [sphereMaterial])
            content.add(sphere)
            sphere.components.set(GroundingShadowComponent(castsShadow: true))
            sphere.components.set(InputTargetComponent())
            sphere.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.2)], isStatic: true))
            sphere.name = "Esfera"
            
            subscription = content.subscribe(to: AnimationEvents.PlaybackCompleted.self, on: sphere) { event in
                touch = false
            }
        } update: { content in
            if touch, let sphere = content.entities.first {
                try? pushSphere(for: sphere)
            }
        }
        .onTapGesture {
            touch.toggle()
        }
    }
    
    func pushSphere(for model: Entity) throws {
        var transform = model.transform
        transform.translation = [0.3, 0.0, 0.0]
        let smallAnimation = FromToByAnimation(to: transform, duration: 0.5, bindTarget: .transform)
        let smallView = AnimationView(source: smallAnimation)
                
        let backAnimation = FromToByAnimation(to: model.transform, duration: 0.5, bindTarget: .transform)
        let backView = AnimationView(source: backAnimation)
        
        let animationGroup = AnimationGroup(group: [smallView, backView])
        
        model.playAnimation(try AnimationResource.generate(with: animationGroup))
    }
}

#Preview(windowStyle: .volumetric) {
    TestRealityView()
}
