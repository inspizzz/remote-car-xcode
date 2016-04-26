//
//  CarController.swift
//  BLEScanner
//
//  Created by Wiktor Wiejak on 17/04/2016.
//  Copyright © 2016 GG. All rights reserved.
//
import CoreBluetooth
import UIKit

// Class managing the car controll screen
class CarController: UIViewController {
    // 
    var ble: BleController!
    // Defines what START means and also when it recieves message STOP it will start the motor
    @IBAction func startMotor(sender: AnyObject) {
        print("Writing START...")
        
        let str = "START"
        let newData = str as NSString
        let writeType = CBCharacteristicWriteType.WithResponse
        ble.currentPeripheral.writeValue(newData.dataUsingEncoding(NSUTF8StringEncoding)!, forCharacteristic: ble.txCharacteristic!, type: writeType)
    }
// Defines what STOP means and also when it recieves the message STOP it will stop the motor if the motor is running otherwise do nothing
    @IBAction func stopMotor(sender: AnyObject) {
        print("Writing STOP...")
        
        let str = "STOP"
        let newData = str as NSString
        let writeType = CBCharacteristicWriteType.WithResponse
        ble.currentPeripheral.writeValue(newData.dataUsingEncoding(NSUTF8StringEncoding)!, forCharacteristic: ble.txCharacteristic!, type: writeType)
    }

// Defines what TURN means and also when it recieves the message TURN it will turn the servo 
    @IBAction func servoSlide(sender: UISlider) {
        
        
        let val = Int(sender.value)
        let str = "TURN:\(val)"
        print(str)
        let newData = str as NSString
        let writeType = CBCharacteristicWriteType.WithResponse
        ble.currentPeripheral.writeValue(newData.dataUsingEncoding(NSUTF8StringEncoding)!, forCharacteristic: ble.txCharacteristic!, type: writeType)
    }
    
    @IBAction func back(sender: UIButton) {
        
        ble.centralManager?.cancelPeripheralConnection(ble.currentPeripheral)
    }
    
    @IBAction func Reverse(sender: UIButton) {
        print("Writing REVERSE")
        let str = "REVERSE"
        let newData = str as NSString
        let writeType = CBCharacteristicWriteType.WithResponse
        ble.currentPeripheral.writeValue(newData.dataUsingEncoding(NSUTF8StringEncoding)!, forCharacteristic: ble.txCharacteristic!, type: writeType)

    }
  
        

}
    
    
    
    
    

