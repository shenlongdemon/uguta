//
//  GenCodeViewController.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 4/30/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit
import QRCode
class GenCodeViewController: BaseViewController {
    var item: String!
    var backToRoot = false
    @IBOutlet weak var imgImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let qrCode = QRCode(self.item)
        imgImage.image = qrCode?.image
        // Do any additional setup after loading the view.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(qrCodeImageTapped(tapGestureRecognizer:)))
        self.imgImage.isUserInteractionEnabled = true
        self.imgImage.addGestureRecognizer(tapGestureRecognizer)
        
        
    }

    @IBAction func print(_ sender: Any) {
        let qrCode = QRCode(self.item)
        Util.print(id: "QRCode", image: qrCode!.image!, frame: self.imgImage.frame, inView: self.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func qrCodeImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        WebApi.getDescriptionQRCode(code: self.item) { (description) in
            Util.showOKAlert(VC: self, message: description);
        }
    }
    func prepareModel(item: String){
        self.item = item
    }
    @IBAction func omidCode(_ sender: Any) {
        self.performSegue(withIdentifier: "omidcode", sender: self.item)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "omidcode"){
            let vc = segue.destination as! OMIDCODEViewController
            vc.prepareModel(item: self.item)
        }
    }
    
    @IBAction func done(_ sender: Any) {
        self.bactToRoot()
    }
    
}
