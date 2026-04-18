import SwiftUI

@main
struct XRFitnessMVPApp: App {
    @StateObject private var model = SpeedModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }

        ImmersiveSpace(id: "FitnessSpace") {
            ImmersiveView(model: model)
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
    }
}
