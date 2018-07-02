//
//  ReviewListViewController.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 7/1/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class ReviewListViewController: BaseViewController {
    
    var items: NSMutableArray = NSMutableArray()
    @IBOutlet weak var tableView: UITableView!
    var tableAdapter : TableAdapter!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initTable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func prepareModel(item : [Review]){
        self.items.removeAllObjects()
        self.items.addObjects(from: item)
    }
    func initTable() {
        let cellIdentifier = ReviewTableViewCell.reuseIdentifier
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        self.tableAdapter = TableAdapter(items:self.items, cellIdentifier: cellIdentifier, cellHeight : ReviewTableViewCell.height)
        self.tableAdapter.onDidSelectRowAt { (item) in
            //let svc = SFSafariViewController(url: URL(string: (item as! ProductSearch).link)!)
            //self.present(svc, animated: true, completion: nil)
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
