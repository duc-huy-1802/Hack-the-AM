// XRSessionConfig.swift — Owner: Nguyen Hoang
// Configures the visionOS ARKit session: world tracking + hand tracking.
// Called once at app launch by XRAdaptiveFitnessApp.swift (Tri's file).

import ARKit
import RealityKit

class XRSessionConfig {

    static let shared = XRSessionConfig()

    private(set) var arkitSession: ARKitSession
    private(set) var worldTracking: WorldTrackingProvider
    private(set) var handTracking: HandTrackingProvider

    private init() {
        arkitSession   = ARKitSession()
        worldTracking  = WorldTrackingProvider()
        handTracking   = HandTrackingProvider()
    }

    /// Call this at app startup to activate spatial tracking
    func startSession() async {
        do {
            try await arkitSession.run([worldTracking, handTracking])
        } catch {
            print("[XRSessionConfig] Session failed to start: \(error)")
        }
    }

    /// Stop tracking (call when app goes to background)
    func stopSession() {
        arkitSession.stop()
    }
}
