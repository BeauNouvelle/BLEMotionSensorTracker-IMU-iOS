//
//  BluetoothManager.swift
//  MovementTracker
//
//  Created by Beau Nouvelle on 7/3/2022.
//

import Foundation
import CoreBluetooth
import Combine
import SwiftUI

enum Status: String {
    case searching
    case connecting
    case connected
    case disconnected
    case error

    var image: Image {
        switch self {
            case .searching:
                return Image(systemName: "hand.raised")
            case .connecting:
                return Image(systemName: "hand.raised.fill")
            case .connected:
                return Image(systemName: "hand.thumbsup.fill")
            case .disconnected:
                return Image(systemName: "hand.raised.slash")
            case .error:
                return Image(systemName: "hand.thumbsdown")
        }
    }

    var color: Color {
        switch self {
            case .searching:
                return .primary
            case .connecting:
                return .teal
            case .connected:
                return .green
            case .disconnected:
                return .orange
            case .error:
                return .red
        }
    }
}

final class BluetoothManager: NSObject, ObservableObject {

    var centralManager: CBCentralManager = CBCentralManager()

    static let shared = BluetoothManager()

    var leftPeripheral: CBPeripheral?
    var rightPeripheral: CBPeripheral?

    // APP ONLY works with these devices.
    let leftID = UUID(uuidString: "EDCF1B27-E0F2-E353-565F-AD7674D797BF")
    let rightID = UUID(uuidString: "24BC79CC-402C-0747-1811-2DF9286F409B")

    var potentialPeripherals: [CBPeripheral] = []

    @Published var leftConnected: Status = .searching
    @Published var rightConnected: Status = .searching

    private var leftAccelData: [AccelerometerData] = []
    private var leftMagData: [AccelerometerData] = []

    private var rightAccelData: [AccelerometerData] = []
    private var rightMagData: [AccelerometerData] = []

    @Published var lAccelX: [Double] = []
    @Published var lAccelY: [Double] = []
    @Published var lAccelZ: [Double] = []

    @Published var lMagX: [Double] = []
    @Published var lMagY: [Double] = []
    @Published var lMagZ: [Double] = []

    @Published var rAccelX: [Double] = []
    @Published var rAccelY: [Double] = []
    @Published var rAccelZ: [Double] = []

    @Published var rMagX: [Double] = []
    @Published var rMagY: [Double] = []
    @Published var rMagZ: [Double] = []

    let capLength = 40

    private override init() { super.init() }

    func start() {
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
    }

}

extension BluetoothManager: BTPeripheralDelegate {
    func peripheral(_ peripheral: BTPeripheral, timeoutDiscoveringServices services: Array<String>) {
        print(services)
    }
}

extension BluetoothManager: CBCentralManagerDelegate {

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("State: \(central.state)")
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil)
        }
        checkFullConnection()
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print(peripheral.identifier)

        if peripheral.identifier == leftID {
            leftConnected = .connected
            peripheral.discoverServices(nil)

            leftPeripheral = peripheral
            leftPeripheral?.delegate = self
        } else if peripheral.identifier == rightID {
            rightConnected = .connected
            peripheral.discoverServices(nil)
        }

        checkFullConnection()
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if peripheral.identifier == leftID {
            leftConnected = .error
        } else if peripheral.identifier == rightID {
            rightConnected = .error
        }

        checkFullConnection()
    }

    func centralManager(_ centralManager: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if (error != nil) {
            print("Disconnected with error: \(error!)")
        }

        if peripheral.identifier == leftID {
            leftPeripheral = nil
            leftConnected = .disconnected
        } else if peripheral.identifier == rightID {
            rightPeripheral = nil
            rightConnected = .disconnected
        }

        checkFullConnection()
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

        guard let name = peripheral.name else {
            return
        }

        guard name.hasPrefix("BBC") else {
            return
        }

        print("ID for BBC Peripheral:", peripheral.identifier)

        if peripheral.identifier == leftID {
            leftPeripheral = peripheral
            leftPeripheral?.delegate = self
            leftConnected = .connecting
        } else if peripheral.identifier == rightID {
            rightPeripheral = peripheral
            rightPeripheral?.delegate = self
            rightConnected = .connecting
        }

        centralManager.connect(peripheral, options: nil)
    }

    func checkFullConnection() {
        if leftPeripheral != nil && rightPeripheral != nil {
            centralManager.stopScan()
        } else {
            centralManager.scanForPeripherals(withServices: nil)
        }
    }

}

extension BluetoothManager: CBPeripheralDelegate {

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services ?? [] {
            print(service.uuid)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for chara in service.characteristics ?? [] {
            print(chara.uuid)
            peripheral.setNotifyValue(true, for: chara)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let char = BTMicrobit.CharacteristicUUID(rawValue: characteristic.uuid.uuidString) else { return }
        switch char {
            case .accelerometerDataUUID:
                let dataBytes = characteristic.value!
                let accelerometerData = dataBytes.withUnsafeBytes {
                    AccelerometerData(x: Int16(littleEndian: $0[0]),
                                      y: Int16(littleEndian: $0[1]),
                                      z: Int16(littleEndian: $0[2]))
                }
                if peripheral.identifier == leftID {
                    leftAccelData.append(accelerometerData)
                    lAccelX.append(Double(accelerometerData.x))
                    lAccelY.append(Double(accelerometerData.y))
                    lAccelZ.append(Double(accelerometerData.z))

                    if lAccelX.count > capLength {
                        lAccelX.removeFirst()
                    }
                    if lAccelY.count > capLength {
                        lAccelY.removeFirst()
                    }
                    if lAccelZ.count > capLength {
                        lAccelZ.removeFirst()
                    }
                } else if peripheral.identifier == rightID {
                    rightAccelData.append(accelerometerData)
                    rAccelX.append(Double(accelerometerData.x))
                    rAccelY.append(Double(accelerometerData.y))
                    rAccelZ.append(Double(accelerometerData.z))

                    if rAccelX.count > capLength {
                        rAccelX.removeFirst()
                    }
                    if rAccelY.count > capLength {
                        rAccelY.removeFirst()
                    }
                    if rAccelZ.count > capLength {
                        rAccelZ.removeFirst()
                    }
                }

            case .magnetometerDataUUID:
                let dataBytes = characteristic.value!
                let magnetometerData = dataBytes.withUnsafeBytes {(int16Ptr: UnsafePointer<Int16>)-> AccelerometerData in
                    AccelerometerData(x: Int16(littleEndian: int16Ptr[0]),
                                     y: Int16(littleEndian: int16Ptr[1]),
                                     z: Int16(littleEndian: int16Ptr[2]))
                }
                if peripheral.identifier == leftID {
                    leftMagData.append(magnetometerData)
                    lMagX.append(Double(magnetometerData.x))
                    lMagY.append(Double(magnetometerData.y))
                    lMagZ.append(Double(magnetometerData.z))

                    if lMagX.count > capLength {
                        lMagX.removeFirst()
                    }
                    if lMagY.count > capLength {
                        lMagY.removeFirst()
                    }
                    if lMagZ.count > capLength {
                        lMagZ.removeFirst()
                    }
                } else if peripheral.identifier == rightID {
                    rightMagData.append(magnetometerData)
                    rMagX.append(Double(magnetometerData.x))
                    rMagY.append(Double(magnetometerData.y))
                    rMagZ.append(Double(magnetometerData.z))

                    if rMagX.count > capLength {
                        rMagX.removeFirst()
                    }
                    if rMagY.count > capLength {
                        rMagY.removeFirst()
                    }
                    if rMagZ.count > capLength {
                        rMagZ.removeFirst()
                    }
                }
            default:
                break
        }


    }
}


struct AccelerometerData {
    let x: Int16
    let y: Int16
    let z: Int16
}
