//
//  BLEDevice.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 5/10/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import Foundation
class BLEDevice: IObject {
    var name: String = ""
    var localName : String = ""
    var distance: Double = 0.0
    override init() {
        super.init()
    }
    func getDistance() -> String {
        let text = String(format: "%.1fm", arguments: [self.distance])
        return text
    }
}
