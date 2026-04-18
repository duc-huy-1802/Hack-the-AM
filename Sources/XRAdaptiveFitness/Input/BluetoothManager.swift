// BluetoothManager.swift — Owner: Nguyen Hoang
// Connects to treadmill via Bluetooth LE using the FTMS standard
// (Fitness Machine Service — the protocol most modern treadmills use)

import CoreBluetooth
import Foundation

class BluetoothManager: NSObject, ObservableObject {

    static let shared = BluetoothManager()

    private var centralManager: CBCentralManager!
    private var treadmillPeripheral: CBPeripheral?

    // FTMS standard UUIDs — works with NordicTrack, LifeFitness, Peloton treadmills
    private let ftmsServiceUUID      = CBUUID(string: "1826")
    private let treadmillDataUUID    = CBUUID(string: "2ACD")

    @Published var isConnected = false
    @Published var isScanning = false
    @Published var statusMessage = "Tap to connect treadmill"

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: .main)
    }

    func startScanning() {
        guard centralManager.state == .poweredOn else {
            statusMessage = "Bluetooth is off — enable it in Settings"
            return
        }
        isScanning = true
        statusMessage = "Scanning for treadmill..."
        centralManager.scanForPeripherals(withServices: [ftmsServiceUUID], options: nil)

        // Stop scan after 10 seconds to save battery
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            self?.stopScanning()
        }
    }

    func stopScanning() {
        centralManager.stopScan()
        isScanning = false
        if !isConnected {
            statusMessage = "No treadmill found — use manual input"
        }
    }

    func disconnect() {
        guard let peripheral = treadmillPeripheral else { return }
        centralManager.cancelPeripheralConnection(peripheral)
    }
}

// MARK: - CBCentralManagerDelegate
extension BluetoothManager: CBCentralManagerDelegate {

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            statusMessage = "Bluetooth ready"
            startScanning()
        case .poweredOff:
            statusMessage = "Bluetooth is off"
            isConnected = false
        case .unauthorized:
            statusMessage = "Bluetooth permission denied"
        default:
            statusMessage = "Bluetooth unavailable"
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
        treadmillPeripheral = peripheral
        treadmillPeripheral?.delegate = self
        central.stopScan()
        isScanning = false
        statusMessage = "Found treadmill, connecting..."
        central.connect(peripheral, options: nil)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        isConnected = true
        statusMessage = "Treadmill connected"
        peripheral.discoverServices([ftmsServiceUUID])
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        isConnected = false
        treadmillPeripheral = nil
        statusMessage = "Treadmill disconnected — reconnecting..."
        // Auto-reconnect
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.startScanning()
        }
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        isConnected = false
        statusMessage = "Connection failed — use manual input"
    }
}

// MARK: - CBPeripheralDelegate
extension BluetoothManager: CBPeripheralDelegate {

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil else { return }
        peripheral.services?.forEach { service in
            peripheral.discoverCharacteristics([treadmillDataUUID], for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard error == nil else { return }
        service.characteristics?.forEach { characteristic in
            if characteristic.uuid == treadmillDataUUID {
                // Subscribe to continuous speed updates from the treadmill
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil, let data = characteristic.value, data.count >= 4 else { return }

        // FTMS Treadmill Data format (Bluetooth spec section 3.68):
        // Bytes 0-1: flags
        // Bytes 2-3: Instantaneous Speed in units of 0.01 km/h (little-endian)
        let rawSpeed = UInt16(data[2]) | (UInt16(data[3]) << 8)
        let speedKmh = Float(rawSpeed) / 100.0

        // Send to normalizer which applies the hysteresis buffer then publishes to GameEvents
        SpeedNormalizer.shared.update(rawSpeed: speedKmh)
    }
}
