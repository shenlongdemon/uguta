//
//  Video360ViewController.swift
//  uguta
//
//  Created by Long Nguyen on 5/16/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit
import OmniVirtSDK
class Video360ViewController: UIViewController {
    @IBOutlet weak var player: VRPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.player
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
