//
//  BluetoothPeripheralManager.swift
//  CoreBluetoothSample
//
//  Created by Yu Wakui on 2024/01/06.
//

import Foundation
import CoreBluetooth
import UIKit

class BluetoothPeripheralManager: NSObject {
    public static let serviceUUID = CBUUID(string: "701A5E8F-A8BE-4286-802C-09A13C8E4A5A")
    private let characteristicUUID = CBUUID(string: UUID().uuidString)
    private var peripheralManager: CBPeripheralManager!
    
    override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }
}

extension BluetoothPeripheralManager {
    
    func publishservice() {
        let service = CBMutableService(type: BluetoothPeripheralManager.serviceUUID, primary: true)
        
        let properties: CBCharacteristicProperties = [.notify, .read]
        let permissions: CBAttributePermissions = [.readable, .writeable]
        let characteristic = CBMutableCharacteristic(
            type: characteristicUUID,
            properties: properties,
            value: nil,
            permissions: permissions
        )
        
        service.characteristics = [characteristic]
        
        peripheralManager.add(service)
    }
    
    func starAdvertise() {
        let advertisementData: [String: Any] = [
            CBAdvertisementDataLocalNameKey: UIDevice.current.model,
            CBAdvertisementDataServiceUUIDsKey: [BluetoothPeripheralManager.serviceUUID]
        ]
        
        peripheralManager.startAdvertising(advertisementData)
    }
    
    func stopAdvertise() {
        peripheralManager.stopAdvertising()
    }
}

extension BluetoothPeripheralManager: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("state: \(peripheral.state)")
        switch peripheral.state {
        case .poweredOn:
            publishservice()
        default:
            break
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        if let error = error {
            print("Failed to add service.\n error: \(error)")
        } else {
            starAdvertise()
        }
        return
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let error = error {
            print("Failed to advertisement.\n error: \(error)")
            return
        }
        print("Success to advertisement.")
    }
}
