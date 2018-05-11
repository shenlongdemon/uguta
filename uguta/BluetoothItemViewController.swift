//
//  BluetoothItemViewController.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 5/10/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit
import CoreBluetooth

protocol ChoiceProto {
    func select(device: BLEDevice)
}

class BluetoothItemViewController: BaseViewController,CBCentralManagerDelegate, CBPeripheralDelegate {
    var choiceProto : ChoiceProto?
    @IBOutlet weak var progress: UIActivityIndicatorView!
    var manager:CBCentralManager!
    var peripheral:CBPeripheral!
    let SERVICE : [CBUUID]? = nil //[CBUUID.init()]
    var devices: NSMutableArray = NSMutableArray()
    var tableAdapter : TableAdapter!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initTable()
        let opts = [CBCentralManagerOptionShowPowerAlertKey: true]
        manager = CBCentralManager(delegate: self, queue: nil, options: opts)
        progress.stopAnimating()
    }
    
    func prepareModel(choiceProto : ChoiceProto){
        self.choiceProto = choiceProto
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    @IBAction func allProduct(_ sender: Any) {
        self.performSegue(withIdentifier: "allproducts", sender: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //timer?.invalidate()
    }
    func scanBLEDevice(){
        print("start scan")
        progress.startAnimating()
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
        self.tableView.reloadData()
        self.progress.stopAnimating()
        
    }
    func prepareModel(){
        
    }
    func initTable() {
        let cellIdentifier = BLEDeviceTableViewCell.reuseIdentifier
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        self.tableAdapter = TableAdapter(items:self.devices, cellIdentifier: cellIdentifier, cellHeight : BLEDeviceTableViewCell.height)
        self.tableAdapter.onDidSelectRowAt { (item) in
            self.choiceProto?.select(device: item as! BLEDevice)
            self.back()
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
        
        if let device = (advertisementData as NSDictionary) .object(forKey: CBAdvertisementDataLocalNameKey) as? NSString {
            bleDevice.name = device as String
        }
        bleDevice.distance = Util.getBLEBeaconDistance(RSSI: RSSI)
        self.devices.add(bleDevice)
        
    }

}




    

