//
//  Product3DTableViewCell.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 6/6/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit
import Foundation
import WebKit
class Product3DTableViewCell: TableCell, WKUIDelegate, WKNavigationDelegate {

    var item: Item!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbCategory: UILabel!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var imgImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func initData(object: IObject) {
        self.item = object as! Item
        self.lbCategory.text = self.item.category.value
        self.imgImage.image = self.item.getImage()
        
        self.lbPrice.text = "$ \(self.item.price)"
        
        self.lbName.text = "\(self.item.name)"
        self.lbStatus.text = ""
        if self.item.buyerCode.count > 0 {
            self.lbStatus.text = "SOLD by \(self.item.buyer?.firstName ?? "" )"
            self.lbStatus.textColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        }
        else if self.item.sellCode.count > 0 {
            self.lbStatus.text = "PUBLISH"
            self.lbStatus.textColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
        }
        if self.item.view3d.count > 0 {
            self.imgImage.isHidden = true
            let url = URL(string: "\(WebApi.HOST)/#/product/view3d?id=\(self.item.id)")
            webView.uiDelegate = self
            webView.navigationDelegate = self
            DispatchQueue.global(qos: .userInitiated).async {
                let request = URLRequest(url: url!)
                // Bounce back to the main thread to update the UI
                DispatchQueue.main.async {
                    self.webView.load(request)
                }
            }
        }
        else {
            self.webView.isHidden = true
            self.imgImage.isHidden = false
        }
        
    }
    @IBAction func next(_ sender: Any) {
        self.performSelect?(self.item)
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
        decisionHandler(.allow)
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let css = "iframe { height : 220px !important; }"
        let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
        webView.evaluateJavaScript(js, completionHandler: nil)
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
    
    static let nibName = String(describing:  Product3DTableViewCell.self)
    static let reuseIdentifier = String(describing: Product3DTableViewCell.self)
    static let height : CGFloat = 320
    
}
