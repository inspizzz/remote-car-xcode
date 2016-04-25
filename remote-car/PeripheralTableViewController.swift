//
//  PeripheralTableViewController.swift
//  BLEScanner
//
//  Created by Wiktor Wiejak on 12/03/2016.
//  Copyright © 2016 GG. All rights reserved.
//


import UIKit


class PeripheralTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var ble: BleController = BleController()
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        ble.startBle(tableView)
    }
    
    //UITableView methods
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        let peripheral = ble.peripherals[indexPath.row]
        let serviceString = (peripheral.name == nil || peripheral.name == "") ? "No device name" : peripheral.name
        
        cell.textLabel?.text = serviceString
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return ble.peripherals.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        ble.centralManager?.stopScan()
        self.performSegueWithIdentifier("carController", sender: indexPath);
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "carController") {
            let carController = segue.destinationViewController as! CarController
            
            ble.connectPeripheral(sender.row)
            carController.ble = ble
       }
    }


 


}
