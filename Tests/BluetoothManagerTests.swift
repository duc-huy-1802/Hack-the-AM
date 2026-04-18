// BluetoothManagerTests.swift — Owner: Nguyen Hoang
import XCTest
@testable import XRAdaptiveFitness

final class BluetoothManagerTests: XCTestCase {

    func testSpeedNormalizerSmoothsSpikes() {
        let normalizer = SpeedNormalizer.shared
        normalizer.reset()

        // Feed 9 slow readings + 1 spike — average should stay low
        for _ in 0..<9 { normalizer.update(rawSpeed: 4.0) }
        normalizer.update(rawSpeed: 20.0)

        // Smoothed speed should be well below the spike
        XCTAssertLessThan(GameEvents.shared.speedKmh, 6.0)
    }

    func testClassifyScenic() {
        let normalizer = SpeedNormalizer.shared
        XCTAssertEqual(normalizer.classify(speed: 0.0), .scenic)
        XCTAssertEqual(normalizer.classify(speed: 5.9), .scenic)
    }

    func testClassifyActive() {
        let normalizer = SpeedNormalizer.shared
        XCTAssertEqual(normalizer.classify(speed: 6.0), .active)
        XCTAssertEqual(normalizer.classify(speed: 10.9), .active)
    }

    func testClassifyRunner() {
        let normalizer = SpeedNormalizer.shared
        XCTAssertEqual(normalizer.classify(speed: 11.0), .runner)
        XCTAssertEqual(normalizer.classify(speed: 20.0), .runner)
    }
}
