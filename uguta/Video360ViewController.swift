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
class Video360ViewController: BaseViewController, WKUIDelegate, WKNavigationDelegate	 {
    
    @IBOutlet weak var progress: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    
    var isDississ : Bool = true
    //@IBOutlet weak var player: VRPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progress.stopAnimating()
        var storeId = "64ec1546-c23d-4b9d-9309-35af7736070f"
        let url = URL(string: "\(WebApi.HOST)/#/store/video360?id=\(storeId)")
        
        let request = URLRequest(url: url!)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.load(request)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isDississ = false
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isDississ = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(true)
    }
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        completionHandler(defaultText)
    }
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let a = 10
        decisionHandler(.allow)
        
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        let a = 10
        decisionHandler(.allow)
    }
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        if let url = navigationAction.request.url  {
            let urlStr = url.absoluteString
            let sp = "iteminsidestore/"
            if urlStr.contains(sp){
                let storeIdAndPosition = urlStr.components(separatedBy: sp)[1].components(separatedBy: "/")
                let storeId =  storeIdAndPosition[0]
                var position =  Int(storeIdAndPosition[1]) as! Int
            
//                if self.progress.isAnimating {
//                    Util.showAlert(message: "Please wait.")
//                }
//                else {
                    self.progress.startAnimating()
                    
                    WebApi.getItemInsideStore(storeId: storeId, position: position, completion: { (i) in
                        self.progress.stopAnimating()
                        guard let item = i else {
                            Util.showAlert(message: "Product is invalid.")
                            return
                        }
                        if (!self.isDississ){
                            self.isDississ = true
                            self.performSegue(withIdentifier: "view3d", sender: item)
                        }
                    })
                //}
            }
        }
        return nil
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "view3d" {
            let vc = segue.destination as! View3DViewController
            vc.prepareModel(item: sender as! Item)
        }
    }
    
    

}
