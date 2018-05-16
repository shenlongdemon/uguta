//
//  User.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 4/29/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class Store: IObject, Mappable {
    var name: String = ""
    var image: String = ""
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.name     <- map["name"]
        self.image     <- map["image"]
    }
    func getImage() -> UIImage? {
        return Util.getImage(data64: self.image)
    }
}


