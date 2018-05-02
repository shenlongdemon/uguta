//
//  BluetoothViewController.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 4/30/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit
import CoreBluetooth

class BluetoothViewController: BaseViewController,CBCentralManagerDelegate, CBPeripheralDelegate {
    
    
    
    @IBOutlet weak var progress: UIActivityIndicatorView!
    var manager:CBCentralManager!
    var peripheral:CBPeripheral!
    @IBOutlet weak var tableView: UITableView!
    var timer : Timer?
    var tableAdapter : TableAdapter!
    var items: NSMutableArray = NSMutableArray()
    var names: NSMutableArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        initTable()
        let opts = [CBCentralManagerOptionShowPowerAlertKey: true]
        manager = CBCentralManager(delegate: self, queue: nil, options: opts)
        progress.stopAnimating()
        timer = Timer.scheduledTimer(timeInterval: 8, target: self,   selector: (#selector(BluetoothViewController.updateTimer)), userInfo: nil, repeats: false)
        timer?.fire()
        
        // Do any additional setup after loading the view.
    }
    @objc func updateTimer() -> Void {
        timer?.invalidate()
        loadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.progress.startAnimating()        
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
        timer?.invalidate()
    }
    func loadData() {
        self.items.removeAllObjects()
        if (self.names.count > 0){
            WebApi.getProductsByBluetoothCodes(codes: self.names as! [String]) { (list) in
                self.items.addObjects(from: list)
                self.names.forEach({ (name) in
                    let i : Item = Item()
                    i.name = name as! String
                    i.id = ""
                    self.items.add(i)
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
        self.items.removeAllObjects()
        self.tableView.reloadData()
        refreshList()
    }
    func refreshList(){
        progress.startAnimating()
        manager.scanForPeripherals(withServices: nil, options: nil)
        timer = Timer.scheduledTimer(timeInterval: 8, target: self,   selector: (#selector(BluetoothViewController.updateTimer)), userInfo: nil, repeats: false)
        timer?.fire()
        
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "bluetoothdevice"){
            let vc = segue.destination as! ProductViewController
            vc.prepareModel(item: sender as! Item)
        }
    }
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("\(central.state )")
        if central.state == .poweredOn {
            central.scanForPeripherals(withServices: nil, options: nil)
            progress.startAnimating()
        } else {
            Util.showOKAlert(VC: self, message: "Please turn on Bluetooth")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let name = peripheral.name
        if !self.names.contains(name) {
            self.names.add(name)
        }
    }
    
   
}
