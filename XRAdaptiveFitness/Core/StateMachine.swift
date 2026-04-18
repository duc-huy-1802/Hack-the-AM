import SwiftUI
import Combine

enum FitnessMode {
    case scenic, active, runner

    var label: String {
        switch self {
        case .scenic: return "SCENIC"
        case .active: return "ACTIVE"
        case .runner: return "RUNNER"
        }
    }

    var color: Color {
        switch self {
        case .scenic: return Color(red: 0.29, green: 0.62, blue: 0.83)
        case .active: return Color(red: 0.94, green: 0.63, blue: 0.19)
        case .runner: return Color(red: 0.91, green: 0.25, blue: 0.25)
        }
    }

    var sceneColor: UIColor {
        switch self {
        case .scenic: return UIColor(red: 0.16, green: 0.44, blue: 0.66, alpha: 1)
        case .active: return UIColor(red: 0.78, green: 0.47, blue: 0.13, alpha: 1)
        case .runner: return UIColor(red: 0.75, green: 0.13, blue: 0.13, alpha: 1)
        }
    }

    var scaleMultiplier: Float {
        switch self {
        case .scenic: return 1.0
        case .active: return 1.15
        case .runner: return 1.35
        }
    }
}

@MainActor
class SpeedModel: ObservableObject {
    @Published var speed: Double = 0.0 {
        didSet { updateMode() }
    }
    @Published var mode: FitnessMode = .scenic

    private func updateMode() {
        if speed < 4 {
            mode = .scenic
        } else if speed < 9 {
            mode = .active
        } else {
            mode = .runner
        }
    }
}
