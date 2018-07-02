//
//  ProductViewController.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 4/29/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class ProductViewController: BaseViewController {
    
    
    
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbCategory: UILabel!
    @IBOutlet weak var imgQR: UIImageView!
    @IBOutlet weak var progress: UIActivityIndicatorView!
    
    @IBOutlet weak var lbOwner: UILabel!
    @IBOutlet weak var btnAction: UIButton!
    @IBOutlet weak var lbPrice: UILabel!
    var item : Item!
    var action = 1
    
    @IBOutlet weak var progressvideo360: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progress.stopAnimating()
        self.progressvideo360.stopAnimating()
        self.imgImage.image = self.item.getImage()
        self.lbName.text = self.item.name
        self.lbCategory.text = self.item.category.value
        self.lbPrice.text = self.item.price
        self.lbOwner.text = "\(self.item.owner.firstName) \(self.item.owner.lastName)"
        self.imgQR.image = Util.getQRCodeImage(str: self.item.getProductCode())
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(qrCodeImageTapped(tapGestureRecognizer:)))
        self.imgQR.isUserInteractionEnabled = true
        self.imgQR.addGestureRecognizer(tapGestureRecognizer)
        
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        self.imgImage.isUserInteractionEnabled = true
        self.imgImage.addGestureRecognizer(tapGestureRecognizer1)
        
        self.makeButtonAction()       
        
    }
    
    @IBAction func print(_ sender: Any) {
        let image = Util.getQRCodeImage(str: self.item.sellCode)
        
        //Util.print(id: "QRCode", image: qrCode!.image!, frame: self.imgImage.frame, inView: self.view)
        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            Util.showAlert(message: "Save error: \(error.localizedDescription)")
        } else {
            Util.showAlert(message: "Your QR Code image has been saved to your photos.")
        }
    }
    @IBAction func gotoStore(_ sender: Any) {
        if self.progressvideo360.isAnimating {
            Util.showAlert(message: "Please wait.")
        }
        else {
            self.progressvideo360.startAnimating()
            WebApi.getStoreContainItem(itemId: self.item.id) { (store) in
                self.progressvideo360.stopAnimating()
                guard let st = store else {
                    Util.showAlert(message: "Item is not set position inside store.")
                    return
                }
                self.performSegue(withIdentifier: "video360product", sender: st)
            }
        }
    }
    
    func makeButtonAction() {
        var title = "SELL"
        let user = StoreUtil.getUser()!
        
        self.btnAction.isEnabled = true
        if item.owner.id == user.id {
            action = 1
            title = "SELL"
            if (self.item.buyerCode.count > 0){
                title = ""
                action = 0
            }
            else if (self.item.sellCode.count > 0){
                title = "" //CANCEL"
                action = 0 // 4
            }
        }
        else if item.owner.id != user.id { // not mine
            action = 2
            title = "BUY"
            if let buyer = item.buyer {
                if buyer.id == user.id { // buyer is me --> confirm that received item
                    action = 3
                    title = "COMFIRM"
                }
            }
        }
        self.btnAction.setTitle(title, for: .normal)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func prepareModel(item: Item){
        self.item = item
        
    }
    @objc func qrCodeImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        WebApi.getDescriptionQRCode(code: self.item.getProductCode()) { (description) in
            Util.showOKAlert(VC: self, message: description);
        }
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if self.item.view3d.count > 0 {
            self.performSegue(withIdentifier: "view3dproduct", sender: self)
        }
        else {
            Util.showAlert(message: "No 3D model.")
        }
    }
    @IBAction func doAction(_ sender: Any) {
        if (action > 0){
            if self.progress.isAnimating{
                Util.showOKAlert(VC: self, message: "Please wait.")
                return
            }
            self.progress.startAnimating()
            if action == 1{
                self.publishSell()
            }
            else if action == 2{
                self.buy()
            }
            else if action == 3{
                self.comfirm()
            }
            else if action == 4{
                self.cancelSell()
            }
        }
    }
   
    func publishSell() {
        Util.getUesrInfo { (history) in
            if let his = history {
                WebApi.publishSell(itemId: self.item.id, ownerInfo: his, completion: { (i) in
                    self.progress.stopAnimating()
                    if let itm = i {
                        self.performSegue(withIdentifier: "publishsell", sender: itm)
                    }
                    else {
                        Util.showOKAlert(VC: self, message: "Cannot publish item to sell.")
                    }
                })
            }
            else {
                self.progress.stopAnimating()
            }
        }
    }
    func comfirm() {
        Util.showYesNoAlert(VC: self, message: "You received product and comfirm?", yesHandle: { () in
            WebApi.confirmReceived(itemId: self.item.id, completion: { (done) in
                self.progress.stopAnimating()
                if (done) {
                    self.bactToRoot()
                }
                else{
                    Util.showOKAlert(VC: self, message: "Error when confirm")
                }
                
            })
        }) { () in
            
        }
       
    }
    func cancelSell() {
        WebApi.cancelSell(itemId: self.item.id, completion: { (done) in
            self.progress.stopAnimating()
            if (done) {
                self.bactToRoot()
            }
            else{
                Util.showOKAlert(VC: self, message: "Error when cancelling.")
            }
            
        })
       
    }
    @IBAction func review(_ sender: Any) {
        self.performSegue(withIdentifier: "searchonweb", sender: self)
    }
    
    @IBAction func gotoMap(_ sender: Any) {
        guard let ble = self.item.bluetooth else {
            Util.showAlert(message: "No bluetooth.")
            return
        }
        self.performSegue(withIdentifier: "productmap", sender: self)
    }
    
    func buy() {
        self.performSegue(withIdentifier: "payment", sender: self.item)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "producthistory" {
            let vc = segue.destination as! HistoryViewController
            vc.prepareModel(item: sender as! Item)
        }
        else if segue.identifier == "publishsell" {
            let vc = segue.destination as! GenCodeViewController
            vc.prepareModel(item: (sender as! Item).sellCode)
        }
        else if segue.identifier == "payment" {
            let vc = segue.destination as! PaymentViewController
            vc.prepareModel(item: sender as! Item)
        }
        else if segue.identifier == "bluetoothcode" {
            let vc = segue.destination as! OMIDCODEViewController
            vc.prepareModel(item: (sender as! Item).getProductCode())
        }
        else if segue.identifier == "productmap" {
            let vc = segue.destination as! ProductMapViewController
            var items : [Item] = [self.item]
            vc.prepareModel(items: items)
        }
        else if segue.identifier == "view3dproduct" {
            let vc = segue.destination as! View3DViewController
            vc.prepareModel(item: self.item)
        }
        else if segue.identifier == "video360product" {
            let vc = segue.destination as! Video360ViewController
            vc.prepareModel(store: sender as! Store)
        }
        else if segue.identifier == "searchonweb" {
            let vc = segue.destination as! ProductSearchViewController
            vc.prepareModel(text: "\(self.item.name) \(self.item.category.value)")
        }
    }
    
    @IBAction func viewHistory(_ sender: Any) {
        if self.progress.isAnimating{
            Util.showOKAlert(VC: self, message: "Please wait")
            return
        }
        self.performSegue(withIdentifier: "producthistory", sender: self.item)
    }
    
    @IBAction func bluetoothCode(_ sender: Any) {
        self.performSegue(withIdentifier: "bluetoothcode", sender: self.item)
    }
    
}
