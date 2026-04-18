// XRAdaptiveFitnessApp.swift — Owner: Tri Nguyen
// App entry point. Tri wires everything together here.

import SwiftUI

@main
struct XRAdaptiveFitnessApp: App {

    init() {
        // Start the XR session on launch (Nguyen's setup)
        Task {
            await XRSessionConfig.shared.startSession()
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
