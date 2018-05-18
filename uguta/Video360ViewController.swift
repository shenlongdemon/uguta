//
//  Video360ViewController.swift
//  uguta
//
//  Created by Long Nguyen on 5/16/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit
import Foundation
import WebKit

//import OmniVirtSDK
class Video360ViewController: BaseViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    
    //@IBOutlet weak var player: VRPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.player
        // Do any additional setup after loading the view.
        

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let iframe = "    <iframe id=\"ado-22036\" src=\"about:blank\" frameborder=\"0\" width=\"1280\" height=\"720\" webkitAllowFullScreen=\"1\" mozallowfullscreen=\"1\" allowFullScreen=\"1\"></iframe><script type=\"text/javascript\">document.getElementById(\"ado-22036\").setAttribute(\"src\", \"//www.vroptimal-3dx-assets.com/content/22036?player=true&autoplay=true&referer=\" + encodeURIComponent(window.location.href));</script><noscript><a href='https://www.omnivirt.com/content/22036/'>Virtual Reality Marketing</a>. <a href='https://www.omnivirt.com/'>Virtual Reality Advertising</a></noscript><script type=\"text/javascript\" src=\"//remote.vroptimal-3dx-assets.com/scripts/vroptimal.js\"></script>"
        let embededHTML = "<html><body>\(iframe)</body></html>"
        let url = URL(string: "https://shenlongdemon.github.io/standard-frontend-angularjs1/#/")
        
        let request = URLRequest(url: url!)
        
        webView.load(request)
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
