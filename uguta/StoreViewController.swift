//
//  StoreViewController.swift
//  uguta
//
//  Created by Long Nguyen on 5/16/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class StoreViewController: BaseViewController {
    @IBOutlet weak var progress: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var tableAdapter : TableAdapter!
    var items: NSMutableArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        initTable()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    func loadData() {
        progress.startAnimating()
        self.items.removeAllObjects()
        WebApi.getStores() { (list) in
            self.items.addObjects(from: list)
            self.tableView.reloadData()
            self.progress.stopAnimating()
        }
    }
    func initTable() {
        let cellIdentifier = StoreTableViewCell.reuseIdentifier
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        self.tableAdapter = TableAdapter(items:self.items, cellIdentifier: cellIdentifier, cellHeight : StoreTableViewCell.height)
        self.tableAdapter.onDidSelectRowAt { (item) in
            
        }
        self.tableView.delegate = self.tableAdapter
        self.tableView.dataSource = self.tableAdapter
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
