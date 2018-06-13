//
//  ProductCollectionViewCell.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 6/8/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
   
    static let nibName = String(describing:  ProductCollectionViewCell.self)
    static let reuseIdentifier = String(describing: ProductCollectionViewCell.self)
    
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var lbName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override convenience init(frame: CGRect) {
        self.init(frame: frame)
    }

}
