//
//  ScanViewModel.swift
//  CoreBluetoothSample
//
//  Created by Yu Wakui on 2024/01/06.
//

import Foundation
import CoreBluetooth

struct PeripheralDevice: Identifiable, Hashable {
    let id: String
    let name: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: PeripheralDevice, rhs: PeripheralDevice) -> Bool {
        return lhs.id == rhs.id
    }
}

class ScanViewModel: ObservableObject {
    @Published var peripheralDevices: Set<PeripheralDevice> = Set<PeripheralDevice>()
    
    private var peripheralManager: BluetoothPeripheralManager!
    private var centralManager: BluetoothCentralManager!
    
    init() {
        peripheralManager = BluetoothPeripheralManager()
        centralManager = BluetoothCentralManager(delegate: self)
    }
}

extension ScanViewModel: BluetoothCentralManagerDelegate {
    func didDiscover(peripheral: CBPeripheral) {
        let peripheralDevice = PeripheralDevice(
            id: peripheral.identifier.uuidString,
            name: peripheral.name ?? ""
        )
        
        if !peripheralDevices.contains(peripheralDevice) {
            peripheralDevices.insert(peripheralDevice)
        }
    }
}
