import SwiftUI
import RealityKit

struct ImmersiveView: View {
    @ObservedObject var model: SpeedModel

    var body: some View {
        RealityView { content in
            let mesh = MeshResource.generateBox(size: 0.25, cornerRadius: 0.02)
            var material = SimpleMaterial()
            material.color = .init(tint: model.mode.sceneColor)
            material.roughness = 0.4
            material.metallic = 0.1

            let entity = ModelEntity(mesh: mesh, materials: [material])
            entity.name = "fitnessBox"
            entity.position = SIMD3(0, 1.5, -1.0)

            content.add(entity)

        } update: { content in
            guard let entity = content.entities.first(where: { $0.name == "fitnessBox" }),
                  let modelEntity = entity as? ModelEntity else { return }

            // Update color
            var material = SimpleMaterial()
            material.color = .init(tint: model.mode.sceneColor)
            material.roughness = mode == .runner ? 0.1 : 0.4
            material.metallic = mode == .runner ? 0.6 : 0.1
            modelEntity.model?.materials = [material]

            // Update scale with animation
            let scale = model.mode.scaleMultiplier
            modelEntity.move(
                to: Transform(scale: SIMD3(scale, scale, scale),
                              translation: SIMD3(0, 1.5, -1.0)),
                relativeTo: nil,
                duration: 0.4,
                timingFunction: .easeInOut
            )
        }
    }

    private var mode: FitnessMode { model.mode }
}

