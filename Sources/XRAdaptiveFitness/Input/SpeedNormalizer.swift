// SpeedNormalizer.swift — Owner: Nguyen Hoang
// Smooths raw speed readings using a rolling average (hysteresis buffer)
// so the environment doesn't flicker when speed bounces at threshold boundaries.
// PRD spec: 3-second rolling average, thresholds Scenic <6 / Active 6-10 / Runner 11+

import Foundation

class SpeedNormalizer {

    static let shared = SpeedNormalizer()

    // ~10 readings over 3 seconds (treadmill broadcasts ~3x/sec via FTMS)
    private let bufferSize = 10
    private var readings: [Float] = []

    private init() {}

    /// Call this every time a new speed value arrives (from Bluetooth or manual input)
    func update(rawSpeed: Float) {
        readings.append(rawSpeed)
        if readings.count > bufferSize {
            readings.removeFirst()
        }

        let smoothed = readings.reduce(0, +) / Float(readings.count)

        // Clamp to realistic treadmill range (0–25 km/h)
        let clamped = min(max(smoothed, 0), 25)

        DispatchQueue.main.async {
            GameEvents.shared.speedKmh = clamped
        }
    }

    /// Classify a speed value into one of the three environment modes
    /// Huy's StateMachine also calls this — defined here as the single source of truth
    func classify(speed: Float) -> IntensityLevel {
        switch speed {
        case ..<6.0:        return .scenic
        case 6.0..<11.0:    return .active
        default:            return .runner
        }
    }

    /// Reset buffer (call at session start)
    func reset() {
        readings.removeAll()
        DispatchQueue.main.async {
            GameEvents.shared.speedKmh = 0.0
        }
    }
}
