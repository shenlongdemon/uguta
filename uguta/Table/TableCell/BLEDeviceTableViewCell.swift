//
//  BLEDeviceTableViewCell.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 5/10/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class BLEDeviceTableViewCell: TableCell {

    @IBOutlet weak var lbId: UILabel!
    @IBOutlet weak var lbLocalName: UILabel!
    @IBOutlet weak var lbName: UILabel!
    var item : BLEDevice!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func initData(object: IObject) {
        self.item = object as! BLEDevice
        self.lbId.text = self.item.id
        self.lbName.text = self.item.name
        self.lbLocalName.text = self.item.localName
       
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func getFrame() -> CGRect {
        return self.frame
    }
    

    
    
    static let nibName = String(describing:  BLEDeviceTableViewCell.self)
    static let reuseIdentifier = String(describing: BLEDeviceTableViewCell.self)
    static let height : CGFloat = 100
}
