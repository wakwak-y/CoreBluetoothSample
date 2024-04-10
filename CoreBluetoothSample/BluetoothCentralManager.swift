//
//  BluetoothCentralManager.swift
//  CoreBluetoothSample
//
//  Created by 和久井侑 on 2024/01/03.
//

import Foundation
import CoreBluetooth

protocol BluetoothCentralManagerDelegate {
    func didDiscover(peripheral: CBPeripheral)
}

class BluetoothCentralManager: NSObject {
    private var centralManager: CBCentralManager!
    private var delegate: BluetoothCentralManagerDelegate
    
    init(delegate: BluetoothCentralManagerDelegate) {
        self.delegate = delegate
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
    }
}

extension BluetoothCentralManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central state: \(central.state)")
        switch central.state {
        case .poweredOn:
            centralManager.scanForPeripherals(withServices: nil)
        default:
            break
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard let uuids = advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] else { return }
        
        if uuids.contains(BluetoothPeripheralManager.serviceUUID) {
            delegate.didDiscover(peripheral: peripheral)
        }
    }
}
