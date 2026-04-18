import SwiftUI
import RealityKit

struct ContentView: View {
    @StateObject private var model = SpeedModel()
    @State private var showImmersive = false
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    var body: some View {
        VStack(spacing: 24) {

            // Mode label
            VStack(spacing: 6) {
                Text("fitness mode")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                    .kerning(2)

                Text(model.mode.label)
                    .font(.system(size: 48, weight: .medium))
                    .foregroundStyle(model.mode.color)
                    .animation(.easeInOut(duration: 0.3), value: model.mode.label)

                Text(modeRange)
                    .font(.caption)
                    .foregroundStyle(model.mode.color.opacity(0.7))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(model.mode.color.opacity(0.12))
                    .clipShape(Capsule())
            }

            Divider()

            // Speed display
            VStack(spacing: 2) {
                Text(String(format: "%.1f", model.speed))
                    .font(.system(size: 64, weight: .medium, design: .rounded))
                    .foregroundStyle(model.mode.color)
                    .animation(.easeInOut(duration: 0.15), value: model.speed)
                Text("km/h")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            // Slider
            VStack(spacing: 8) {
                Slider(value: $model.speed, in: 0...15, step: 0.1)
                    .tint(model.mode.color)
                    .animation(.easeInOut(duration: 0.3), value: model.mode.color)
                    .padding(.horizontal)

                HStack {
                    Text("0").font(.caption).foregroundStyle(.tertiary)
                    Spacer()
                    Text("15 km/h").font(.caption).foregroundStyle(.tertiary)
                }
                .padding(.horizontal)
            }

            Divider()

            // Immersive scene toggle
            Button(showImmersive ? "Exit Immersive View" : "Enter Immersive View") {
                Task {
                    if showImmersive {
                        await dismissImmersiveSpace()
                        showImmersive = false
                    } else {
                        await openImmersiveSpace(id: "FitnessSpace")
                        showImmersive = true
                    }
                }
            }
            .buttonStyle(.bordered)
        }
        .padding(32)
        .frame(minWidth: 360, maxWidth: 480)
    }

    private var modeRange: String {
        switch model.mode {
        case .scenic: return "0 – 4 km/h"
        case .active: return "5 – 9 km/h"
        case .runner: return "10+ km/h"
        }
    }
}
