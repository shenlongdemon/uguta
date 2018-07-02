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
        loadData()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
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
            //let svc = SFSafariViewController(url: URL(string: (item as! ProductSearch).link)!)
            //self.present(svc, animated: true, completion: nil)
            
        }
        self.tableAdapter.onDidPerformSelectRowAt { (item, type) in
            let i = item as! ProductSearch
            if type == 1{
                if i.reviews.count > 0 {
                    self.performSegue(withIdentifier: "reviewobweb", sender: item)
                }
                else {
                    Util.showAlert(message: "Have no review.")
                }
            }
            else {
                let svc = SFSafariViewController(url: URL(string: i.link)!)
                self.present(svc, animated: true, completion: nil)
            }
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
        if segue.identifier == "reviewobweb" {
            let vc = segue.destination as! ReviewListViewController
            vc.prepareModel(item: (sender as! ProductSearch).reviews)
        }
    }
    
    @IBAction func newItem(_ sender: Any) {
        self.performSegue(withIdentifier: "fillitem", sender: nil)
    }
}
