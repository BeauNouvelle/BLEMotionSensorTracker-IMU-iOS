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
import SwiftUICharts

final class BluetoothManager: NSObject, ObservableObject {

    var centralManager: CBCentralManager = CBCentralManager()

    static let shared = BluetoothManager()

    var leftPeripheral: CBPeripheral?
    var rightPeripheral: CBPeripheral?

    // APP ONLY works with these devices.
    static let S_SERVICE_UUID =  CBUUID(string: "e58919dd-8e27-4a31-8675-af7c16034cb9".uppercased())
    static let M_CHARACTERISTIC_UUID =  CBUUID(string: "343a4a81-51bc-4aec-93a7-b344107064c1")
    static let T_CHARACTERISTIC_UUID =  CBUUID(string: "23f75411-dec3-420c-84d8-889a370fee79")

    @Published var leftConnected: BluetoothStatus = .searching
    @Published var rightConnected: BluetoothStatus = .searching

    private var leftMotionDataCache: [MotionData] = []
    private var rightMotionDataCache: [MotionData] = []

    var leftChartData: [(ax: LineChartDataPoint, ay: LineChartDataPoint, az: LineChartDataPoint, gx: LineChartDataPoint, gy: LineChartDataPoint, gz: LineChartDataPoint)] = []
    var rightChartData: [(ax: LineChartDataPoint, ay: LineChartDataPoint, az: LineChartDataPoint, gx: LineChartDataPoint, gy: LineChartDataPoint, gz: LineChartDataPoint)] = []

    @Published var latestLeftReading: MotionData = .init(a: .init(), g: .init())
    @Published var latestRightReading: MotionData = .init(a: .init(), g: .init())

    @Published var trackingData = false
    @Published var captureType: CaptureType = .jab

    let countdown = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()

    private override init() { super.init() }

    func start() {
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
    }

    private func capture() {
        let snapshot = snapshot(cap: captureType)
        do {
            let jsonData = try JSONEncoder().encode(snapshot.rows)
            SaveManager.save(json: jsonData, type: captureType)
        } catch {
            print(error.localizedDescription)
        }
    } 

    private func snapshot(cap: CaptureType) -> Snapshot {

        if leftPeripheral == nil {
            leftMotionDataCache = Array(repeating: MotionData(a: .init(), g: .init()), count: rightMotionDataCache.count)
        }

        if rightPeripheral == nil {
            rightMotionDataCache = Array(repeating: MotionData(a: .init(), g: .init()), count: leftMotionDataCache.count)
        }

        let snapshot = Snapshot(
            leftMotionData: leftMotionDataCache,
            rightMotionData: rightMotionDataCache,
            type: cap)
        return snapshot
    }

    func startRecording() {
        clearStream()
    }

    func saveRecording() {
        guard !leftMotionDataCache.isEmpty && !rightMotionDataCache.isEmpty else {
            return
        }
        capture()
        clearStream()
    }

    func clearStream() {
        leftMotionDataCache.removeAll()
        rightMotionDataCache.removeAll()
    }

    private func startScan() {
        print("scanning")
        centralManager.scanForPeripherals(withServices: [BluetoothManager.S_SERVICE_UUID])
    }

}

extension BluetoothManager: CBCentralManagerDelegate {

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            startScan()
        }
        checkFullConnection()
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if leftPeripheral == peripheral {
            leftConnected = .connected
        } else if rightPeripheral == peripheral {
            rightConnected = .connected
        } else {
            print("WTF. We already have two connected!")
            return
        }

        peripheral.delegate = self
        peripheral.discoverServices([BluetoothManager.S_SERVICE_UUID])

        checkFullConnection()
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if leftPeripheral == peripheral {
            leftPeripheral = nil
            leftConnected = .error
        } else if rightPeripheral == peripheral {
            rightPeripheral = nil
            rightConnected = .error
        }
        checkFullConnection()
    }

    // todo: we'll need to be smarter with the conenctions.
    // saving UUID to device would be best, then we can connect easier and keep track of left and right.
    func centralManager(_ centralManager: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if (error != nil) {
            print(error!.localizedDescription)
        }

        if peripheral == leftPeripheral {
            leftPeripheral = nil
            leftConnected = .disconnected
            print("disconnected left")
        } else if peripheral == rightPeripheral {
            rightPeripheral = nil
            rightConnected = .disconnected
            print("disconnected right")
        }
        checkFullConnection()
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // we HAVE to keep a reference here, otherwise it's forgotten when we finialize connection.
        // and CB yells at us.
        if leftPeripheral == nil && peripheral != rightPeripheral {
            leftPeripheral = peripheral
            leftConnected = .connecting
        } else if rightPeripheral == nil && peripheral != leftPeripheral {
            rightPeripheral = peripheral
            rightConnected = .connecting
        } else {
            print("Found others?")
            return
        }

        centralManager.connect(peripheral, options: nil)
    }

    func checkFullConnection() {
        if leftPeripheral == nil || rightPeripheral == nil {
            startScan()
        } else {
            //  both are connected so we can stop scanning.
            centralManager.stopScan()
        }
    }

}

extension BluetoothManager: CBPeripheralDelegate {

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services ?? [] {
            peripheral.discoverCharacteristics([BluetoothManager.M_CHARACTERISTIC_UUID, BluetoothManager.T_CHARACTERISTIC_UUID], for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for chara in service.characteristics ?? [] {
            peripheral.setNotifyValue(true, for: chara)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == BluetoothManager.M_CHARACTERISTIC_UUID {
            guard let data = characteristic.value else { return }
            do {
                let motionData = try JSONDecoder().decode(MotionData.self, from: data)
                if peripheral == leftPeripheral {
                    latestLeftReading = motionData

                    if trackingData {
                        leftMotionDataCache.append(motionData)
                        leftChartData.append(motionData.chartData())
                        if leftChartData.count > 30 {
                            leftChartData.removeFirst()
                        }
                    }
                } else if peripheral == rightPeripheral {
                    latestRightReading = motionData

                    if trackingData {
                        rightMotionDataCache.append(motionData)
                        rightChartData.append(motionData.chartData())
                        if rightChartData.count > 30 {
                            rightChartData.removeFirst()
                        }
                    }

                } else {
                    print("WTF. Where did this come from?")
                }
            } catch {
                print(error.localizedDescription)
            }
        }

        if characteristic.uuid == BluetoothManager.T_CHARACTERISTIC_UUID {
            // todo: if we need it. could be cool
        }
    }
}
