//
//  StoreTableViewCell.swift
//  uguta
//
//  Created by Long Nguyen on 5/16/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class StoreTableViewCell: TableCell {
    var item: Store!
    @IBOutlet weak var lbName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func initData(object: IObject) {
        self.item = object as! Store
        self.lbName.text = self.item.name
        
        
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
        
    static let nibName = String(describing:  StoreTableViewCell.self)
    static let reuseIdentifier = String(describing: StoreTableViewCell.self)
    static let height : CGFloat = 100
}
