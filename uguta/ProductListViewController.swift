//
//  ProductListViewController.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 4/29/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class ProductListViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var progress: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var category: Category!
    var tableAdapter : TableAdapter!
    var items: NSMutableArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        progress.stopAnimating()
        //initTable()
        initCollection()
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
    func prepareModel(cat: Category){
        self.category = cat
    }
    func initCollection() {
        let cellNib = UINib(nibName: ProductCollectionViewCell.nibName, bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: ProductCollectionViewCell.reuseIdentifier)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
    }
    func initTable() {
        let cellIdentifier = Product3DTableViewCell.reuseIdentifier
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        self.tableAdapter = TableAdapter(items:self.items, cellIdentifier: cellIdentifier, cellHeight : Product3DTableViewCell.height)
        self.tableAdapter.onDidSelectRowAt { (item) in
            self.performSegue(withIdentifier: "productdetail", sender: item)
        }
        self.tableView.delegate = self.tableAdapter
        self.tableView.dataSource = self.tableAdapter
        
    }
    func loadData() {
        progress.startAnimating()
        items.removeAllObjects()
        WebApi.getProductsByCategory(categoryId: self.category.id) { (list) in
            self.items.addObjects(from: list)
            //self.tableView.reloadData()
            self.collectionView.reloadData()
            self.progress.stopAnimating()
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ProductViewController
        vc.prepareModel(item: sender as! Item)        
    }
 

}
extension ProductListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.items[indexPath.row] as! Item
        self.performSegue(withIdentifier: "productdetail", sender: item)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.reuseIdentifier, for: indexPath) as! ProductCollectionViewCell
        
        let item = self.items[indexPath.row] as! Item
        
        cell.imgImage.image = item.getImage()
        cell.lbName.text = item.name
        cell.lbPrice.text = item.price
//        cell.lbStatus.text = ""
//        if item.buyerCode.count > 0 {
//            cell.lbStatus.text = "SOLD by \(item.buyer?.firstName ?? "" )"
//            cell.lbStatus.textColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
//        }
//        else if item.sellCode.count > 0 {
//            cell.lbStatus.text = "PUBLISH"
//            cell.lbStatus.textColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
//        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding : CGFloat = 5.0
        let count : CGFloat = 2
        
        let size = collectionView.frame.size.width / count  - padding
        return CGSize(width: size , height: size )
    }
    
}

