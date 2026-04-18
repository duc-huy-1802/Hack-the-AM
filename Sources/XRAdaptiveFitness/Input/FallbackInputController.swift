// FallbackInputController.swift — Owner: Nguyen Hoang
// Manual speed input for treadmills without Bluetooth, or as a demo backup.
// Show this view if BluetoothManager.isConnected == false.

import SwiftUI

struct FallbackInputController: View {

    @ObservedObject private var events = GameEvents.shared
    @ObservedObject private var bluetooth = BluetoothManager.shared

    var body: some View {
        VStack(spacing: 24) {

            // Connection status banner
            HStack {
                Circle()
                    .fill(bluetooth.isConnected ? Color.green : Color.orange)
                    .frame(width: 10, height: 10)
                Text(bluetooth.statusMessage)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            // Current speed readout
            VStack(spacing: 4) {
                Text("\(String(format: "%.1f", events.speedKmh))")
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                Text("km/h")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                Text(modeName)
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(modeColor.opacity(0.2))
                    .foregroundStyle(modeColor)
                    .clipShape(Capsule())
            }

            // Speed slider
            VStack(spacing: 8) {
                Slider(
                    value: Binding(
                        get: { Double(events.speedKmh) },
                        set: { SpeedNormalizer.shared.update(rawSpeed: Float($0)) }
                    ),
                    in: 0...20,
                    step: 0.5
                )
                .tint(modeColor)

                HStack {
                    Text("0")
                    Spacer()
                    Text("10")
                    Spacer()
                    Text("20 km/h")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            // Quick preset buttons
            HStack(spacing: 16) {
                presetButton(label: "Walk", speed: 4.0, color: .green)
                presetButton(label: "Jog",  speed: 8.0, color: .orange)
                presetButton(label: "Run",  speed: 13.0, color: .red)
            }

            // Retry Bluetooth button
            if !bluetooth.isConnected {
                Button {
                    BluetoothManager.shared.startScanning()
                } label: {
                    Label(
                        bluetooth.isScanning ? "Scanning..." : "Retry Bluetooth",
                        systemImage: "antenna.radiowaves.left.and.right"
                    )
                }
                .buttonStyle(.bordered)
                .disabled(bluetooth.isScanning)
            }
        }
        .padding(32)
    }

    // MARK: - Helpers

    private var modeName: String {
        switch events.intensity {
        case .scenic:  return "SCENIC MODE"
        case .active:  return "ACTIVE MODE"
        case .runner:  return "RUNNER MODE"
        }
    }

    private var modeColor: Color {
        switch events.intensity {
        case .scenic:  return .green
        case .active:  return .orange
        case .runner:  return .red
        }
    }

    private func presetButton(label: String, speed: Float, color: Color) -> some View {
        Button {
            SpeedNormalizer.shared.update(rawSpeed: speed)
        } label: {
            VStack(spacing: 2) {
                Text(label)
                    .font(.headline)
                Text("\(String(format: "%.0f", speed)) km/h")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
        }
        .buttonStyle(.bordered)
        .tint(color)
    }
}

#Preview {
    FallbackInputController()
}
