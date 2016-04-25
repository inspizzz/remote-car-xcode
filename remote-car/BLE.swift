//
//  BLE.swift
//  BLEScanner
//
//  Created by Wiktor Wiejak on 18/04/2016.
//  Copyright © 2016 GG. All rights reserved.
//



// Here we import libraries
import UIKit
import CoreBluetooth

// Here we add a class and define its parents
class BleController: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    // Defines variables
    var tableView: UITableView!
    var centralManager: CBCentralManager?
    var currentPeripheral:CBPeripheral!
    var rxCharacteristic:CBCharacteristic!
    var txCharacteristic:CBCharacteristic!
    var uartService:CBService?
    var peripherals: Array<CBPeripheral> = Array<CBPeripheral>()
    
    // This activates BLE
    func startBle(tableView: UITableView) {
        self.tableView = tableView
        centralManager = CBCentralManager(delegate: self, queue: dispatch_get_main_queue())
    }
    
    // CoreBluetooth methods
    
    // If Bluetooth on phone changes state to powered on, start scanning for peripheral
    func centralManagerDidUpdateState(central: CBCentralManager)
    {
        if (central.state == CBCentralManagerState.PoweredOn)
        {
            self.centralManager?.scanForPeripheralsWithServices(nil, options: nil)
        }
        else
        {
            // do something like alert the user that ble is not on
        }
    }
    // this will show the different bluetooth device names
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        print("didDiscoveryPeripheral")
        
        // Check if we have seen this Peripheral( Bluetooth devices)
        for p in peripherals {
            if p.identifier == peripheral.identifier {
                return
            }
        }
        
        // If peripheral is not known to our class add it to peripherals array
        peripherals.append(peripheral)
        // Reloads data on table
        tableView.reloadData()
   
    
    }
    
    // connects to that Peripheral in certain array cell
    func connectPeripheral(row: Int) {
        currentPeripheral = peripherals[row]
        centralManager!.connectPeripheral(currentPeripheral, options: [:])
    }
    
    // When Peripheral connection is completed - discover services
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("didConnectPeripheral")
        
        currentPeripheral.delegate = self
        currentPeripheral.discoverServices([uartServiceUUID()])
    }
    
    // When services are discovered, discover characteristic
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        print("didDiscoverServices")
        
        for s in peripheral.services as [CBService]! {
            print("- " + s.UUID.UUIDString)
            if (s.UUID.UUIDString == uartServiceUUID().UUIDString) {
                uartService = s
                peripheral.discoverCharacteristics([txCharacteristicUUID(), rxCharacteristicUUID()], forService: uartService!)
                
            }
        }
        
    }
    
    // When characteristics are discovered record them for future use
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        print("didDiscoverCharacteristic")
        
        for c in (service.characteristics as [CBCharacteristic]!) {
            print("- " + c.UUID.UUIDString)
            switch c.UUID {
            case rxCharacteristicUUID():
                rxCharacteristic = c
                currentPeripheral.setNotifyValue(true, forCharacteristic: rxCharacteristic!)
                break
            case txCharacteristicUUID():
                txCharacteristic = c
                break
            default:
                break
            }
            
        }
    }

}

// These are Identifiers of services and characteristics
func uartServiceUUID()->CBUUID {
    return CBUUID(string: "6e400001-b5a3-f393-e0a9-e50e24dcca9e")
    
}


func txCharacteristicUUID()->CBUUID {
    return CBUUID(string: "6e400002-b5a3-f393-e0a9-e50e24dcca9e")
}


func rxCharacteristicUUID()->CBUUID {
    return CBUUID(string: "6e400003-b5a3-f393-e0a9-e50e24dcca9e")
}


