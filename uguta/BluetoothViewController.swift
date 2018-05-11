//
//  BluetoothViewController.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 4/30/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit
import CoreBluetooth
import SwiftyJSON

class BluetoothViewController: BaseViewController,CBCentralManagerDelegate, CBPeripheralDelegate {
    
    
    
    @IBOutlet weak var progress: UIActivityIndicatorView!
    var manager:CBCentralManager!
    var peripheral:CBPeripheral!
    @IBOutlet weak var tableView: UITableView!
    //var timer : Timer?
    var tableAdapter : TableAdapter!
    var items: NSMutableArray = NSMutableArray()
    var devices: NSMutableArray = NSMutableArray()
    let SERVICE : [CBUUID]? = nil //[CBUUID.init()]
    override func viewDidLoad() {
        super.viewDidLoad()
        initTable()
        let opts = [CBCentralManagerOptionShowPowerAlertKey: true]
        manager = CBCentralManager(delegate: self, queue: nil, options: opts)
        progress.stopAnimating()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)        
    }
    @IBAction func allProduct(_ sender: Any) {
        self.performSegue(withIdentifier: "allproducts", sender: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //timer?.invalidate()
    }
    func scanBLEDevice(){
        print("start scan")
        progress.startAnimating()
        self.items.removeAllObjects()
        self.devices.removeAllObjects()
        self.tableView.reloadData()
        manager?.scanForPeripherals(withServices: nil, options: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
            self.stopScanForBLEDevice()
            self.loadData()
        }
        
    }
    func stopScanForBLEDevice(){
        manager?.stopScan()
        print("scan stopped")
    }
    func loadData() {
        self.items.removeAllObjects()
        self.tableView.reloadData()

        if (self.devices.count > 0){
            let names = self.devices.map({ (device) -> String in
                return (device as! BLEDevice).id
            })
            WebApi.getProductsByBluetoothCodes(codes: names as! [String]) { (list) in
                self.items.addObjects(from: list)
                self.devices.forEach({ (device) in
                    if let d = device as? BLEDevice{
                        let i : Item = Item()
                        i.name = d.name
                        i.description = d.localName
                        i.bluetoothCode = d.id
                        i.price = d.getDistance()
                        i.id = ""
                        self.items.add(i)
                    }
                })
                self.tableView.reloadData()
                self.progress.stopAnimating()
            }
        }
        else {
            self.progress.stopAnimating()
        }
        
    }
    func prepareModel(){
        
    }
    func initTable() {
        let cellIdentifier = ProductTableViewCell.reuseIdentifier
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        self.tableAdapter = TableAdapter(items:self.items, cellIdentifier: cellIdentifier, cellHeight : ProductTableViewCell.height)
        self.tableAdapter.onDidSelectRowAt { (item) in
            if item.id.count > 0{
                self.performSegue(withIdentifier: "bluetoothdevice", sender: item)
            }
        }
        self.tableView.delegate = self.tableAdapter
        self.tableView.dataSource = self.tableAdapter
        
    }
    @IBAction func refresh(_ sender: Any) {
        if progress.isAnimating {
            Util.showOKAlert(VC: self, message: "Please wait")
            return
        }
        
        refreshList()
    }
    func refreshList(){
        
        self.scanBLEDevice()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "bluetoothdevice"){
            let vc = segue.destination as! ProductViewController
            vc.prepareModel(item: sender as! Item)
        }
    }
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch(central.state){
            case .poweredOn:
                print("Bluetooth is powered ON")
            case .poweredOff:
                print("Bluetooth is powered OFF")
            case .resetting:
                print("Bluetooth is resetting")
            case .unauthorized:
                print("Bluetooth is unauthorized")
            case .unknown:
                print("Bluetooth is unknown")
            case .unsupported:
                print("Bluetooth is not supported")
        }
        if central.state == .poweredOn {
            self.scanBLEDevice()
        } else {
            Util.showOKAlert(VC: self, message: "Please turn on Bluetooth")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        let bleDevice = BLEDevice()
        
        bleDevice.id = peripheral.identifier.uuidString
        
        if let name = peripheral.name {
            bleDevice.name = name
        }
        //if !hasName {
        if let device = (advertisementData as NSDictionary) .object(forKey: CBAdvertisementDataLocalNameKey) as? NSString {
            bleDevice.name = device as String
        }
        bleDevice.distance = Util.getBLEBeaconDistance(RSSI: RSSI)
        self.devices.add(bleDevice)
        
    }
    

}
