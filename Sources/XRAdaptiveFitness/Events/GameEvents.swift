// GameEvents.swift — Owner: Huy Nguyen (READ-ONLY for everyone else)
// Shared state bus: everyone reads from here, only designated owners write

import Foundation
import Combine

enum IntensityLevel {
    case scenic   // 0–5 km/h
    case active   // 6–10 km/h
    case runner   // 11+ km/h
}

class GameEvents: ObservableObject {
    static let shared = GameEvents()

    @Published var intensity: IntensityLevel = .scenic
    @Published var speedKmh: Float = 0.0          // Nguyen writes this
    @Published var score: Int = 0                  // Huy writes this
    @Published var multiplier: Float = 1.0         // Huy writes this
    @Published var transitionProgress: Float = 0.0 // Huy writes this
    @Published var sessionDurationSec: Int = 0     // Huy writes this

    private init() {}
}
