//
//  ProductSearchViewController.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 6/21/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit
import SafariServices
class ProductSearchViewController: BaseViewController {
    var text: String!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progress: UIActivityIndicatorView!
    var tableAdapter : TableAdapter!
    var items: NSMutableArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        initTable()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func prepareModel(text: String){
        self.text = text
    }
    
    func initTable() {
        let cellIdentifier = ProductSearchTableViewCell.reuseIdentifier
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        self.tableAdapter = TableAdapter(items:self.items, cellIdentifier: cellIdentifier, cellHeight : ProductSearchTableViewCell.height)
        self.tableAdapter.onDidSelectRowAt { (item) in
            
            let svc = SFSafariViewController(url: URL(string: (item as! ProductSearch).link)!)
            self.present(svc, animated: true, completion: nil)
        }
        self.tableView.delegate = self.tableAdapter
        self.tableView.dataSource = self.tableAdapter
        
    }
    func loadData() {
        progress.startAnimating()
        items.removeAllObjects()
        self.tableView.reloadData()
        WebApi.getProductSearch(name: self.text) { (list) in
            self.items.addObjects(from: list)
            self.tableView.reloadData()
            self.progress.stopAnimating()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemdetail" {
            let vc = segue.destination as! ProductViewController
            vc.prepareModel(item: sender as! Item)
        }
    }
    
    @IBAction func newItem(_ sender: Any) {
        self.performSegue(withIdentifier: "fillitem", sender: nil)
    }
}
