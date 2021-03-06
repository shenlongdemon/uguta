//
//  FillItemViewController.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 4/30/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit
import DropDown
class FillItemViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ChoiceProto {
    func select(device: BLEDevice) {
        self.bluetoothDevice = device
        self.txtBluetoothName.text = self.bluetoothDevice!.name
        self.lbBluetoothId.text = self.bluetoothDevice!.id
        
    }
    
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var progress: UIActivityIndicatorView!
    
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtBluetoothName: UITextField!
    
    @IBOutlet weak var lbBluetoothId: UILabel!
    var categories: [Category] = []
    let dropDown = DropDown()
    var selectCategpry : Category?
    var bluetoothDevice: BLEDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progress.stopAnimating()
        loadCategories()
        imagePicker.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pickImage(tapGestureRecognizer:)))
        self.imgImage.isUserInteractionEnabled = true
        self.imgImage.addGestureRecognizer(tapGestureRecognizer)
        
        dropDown.anchorView = self.txtCategory
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectCategpry = self.categories[index]
            self.txtCategory.text = item
        }
        // Do any additional setup after loading the view.
    }
    func loadCategories(){
        WebApi.getCategories { (list) in
            self.categories.removeAll()
            self.categories.append(contentsOf: list)
            let names = list.map({ (cate) -> String in
                return cate.value
            })
            self.dropDown.dataSource = names
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func touchDown(_ sender: Any) {
         dropDown.show()
    }
    @IBAction func showCategories(_ sender: Any) {
        dropDown.show()
    }
    @objc func pickImage(tapGestureRecognizer: UITapGestureRecognizer)
    {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let image = Util.resizeImage(image: pickedImage)
            imgImage.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        if self.progress.isAnimating {
            Util.showOKAlert(VC: self, message: "Please wait")
            return
        }
        
        guard  let cat = self.selectCategpry else {
            Util.showOKAlert(VC: self, message: "Please select category")
            return
        }
        
        self.progress.startAnimating()
        let device = self.bluetoothDevice?.id ?? ""
           
        let item : Item = Item()
        item.name = txtName.text!
        item.price = txtPrice.text!
        item.description = txtDescription.text
        item.category = cat
        item.image = Util.getData64(image: imgImage.image)
        item.bluetoothCode = device
        
        Util.getUesrInfo { (history) in
            if let his = history {
                if let ble = self.bluetoothDevice {
                    item.location = BLEPosition()
                    item.location.coord = ble.coord
                }                
                item.owner = his
                WebApi.addItem(item: item, completion: { (item) in
                    if let it = item {
                        self.performSegue(withIdentifier: "doneadditem", sender: it)
                    }
                    else{
                        Util.showOKAlert(VC: self, message: "Cannot add item")
                    }
                    self.progress.stopAnimating()
                    
                })
            }
            else{
                self.progress.stopAnimating()
            }
        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bluetoothitem" {
            let vc = segue.destination as! BluetoothItemViewController
            vc.prepareModel(choiceProto: self)
        }
        else if segue.identifier == "doneadditem" {
            let sellCode = (sender as! Item).sellCode
            let vc = segue.destination as! GenCodeViewController
            
            vc.prepareModel(item: sellCode)
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
