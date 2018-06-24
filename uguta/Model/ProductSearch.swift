//
//  Item.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 4/29/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class ProductSearch: IObject, Mappable {
    var link: String = ""
    var image: String = ""
    var title: String = ""
    var index: Int = 0
    var reviews: Int = 0
    var price: String = ""
    var currency: String = ""
    var rate: Int = -1
    override init() {
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.title <- map["title"]
        self.link <- map["link"]
        self.image <- map["image"]
        self.index <- map["index"]
        self.reviews <- map["reviews"]
        self.price <- map["price"]
        self.currency <- map["currency"]
        self.rate <- map["rate"]    
    }
    func getImage(completion: @escaping (_ image:UIImage?)->Void){
        WebApi.getImage(url: self.image) { (img) in
            completion(img)
        }
    }
}
