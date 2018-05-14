//
//  Util.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 4/29/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import Foundation
import UIKit
import QRCode
import DataCompression
import Alamofire
import ObjectMapper
class Util {
    static let transformDouble = TransformOf<Double, String>(fromJSON: { (value: String?) -> Double? in
        // transform value from String? to Int?
        if let v = value {
            return Double(v)
        }
        else {
            return nil
        }
    }, toJSON: { (value: Double?) -> String? in
        // transform value from Int? to String?
        if let value = value {
            return String(value)
        }
        return nil
    })
    static func getImage(data64: String) -> UIImage? {
        var uiimage:UIImage? = nil
        if (data64 != ""){
            let dataDecoded : Data = Data(base64Encoded: data64, options: .ignoreUnknownCharacters)!
            uiimage = UIImage(data: dataDecoded)
        }
        return uiimage
    }
    static func getQRCodeImage(str: String) -> UIImage?{
        var image : UIImage? = nil
        do{
            let qrCode = QRCode(str)
            image = qrCode?.image
        }
        catch _{
        
        }
        return image
    }
    static func showYesNoAlert(VC:UIViewController,  message:String?, yesHandle: @escaping (_ action:Void)->Void, noHandle: @escaping (_ action:Void)->Void){
        
            let alert = UIAlertController(title: "uGuta", message: message ?? "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(alert: UIAlertAction!) in
                yesHandle(())
                
            }))
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: {(alert: UIAlertAction!) in
                
            }))
            VC.present(alert, animated: true, completion: nil)
        
    }
    static func showOKAlert(VC:UIViewController,  message:String?)-> Void {
        let alert = UIAlertController(title: "uGuta", message: message ?? "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        VC.present(alert, animated: true, completion: nil)
    }
    
    static func showAlert(message:String?)-> Void {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            let alert = UIAlertController(title: "uGuta", message: message ?? "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            topController.present(alert, animated: true, completion: nil)
            // topController should now be your topmost view controller
        }
        
    }
        
        
    
    static func resizeImage(image : UIImage) -> UIImage{
       
        let newSize: CGSize = CGSize(width: 70, height: 70)
       
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: 70, height: 70)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    static func getData64(image: UIImage?) -> String{
        guard let img = image else {
            return ""
        }
        let imageData:NSData = UIImagePNGRepresentation(img)! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        return strBase64
    }
    static func getUesrInfo(completion: @escaping (_ history: History )->Void){
        var history : History = Store.getUserHistory()!
        history.position = Store.getPosition()!
        WebApi.getWeather(lat: history.position.coord.latitude, lon: history.position.coord.longitude) { (weather) in
            if let wa = weather {
                history.weather = wa
                let nowDoublevaluseis = NSDate().timeIntervalSince1970
                history.time = Int64(nowDoublevaluseis*1000)
                completion(history)
            }
            else {
                Util.showAlert(message: "Cannot get weather.")
            }
        }
    }

    static func drawOMIDCode(strCode : String) -> UIImage{
        let str = strCode.lowercased()
//        let a = "____-__0__1__2__3__4__5__6__7__8__9__a__b__c__d__e__f__g__h__i__j__k__l__m__n__o__p__q__r__s__t__u__v__w__x__y__z";
//        let chacs = "abcdefghijklmnopqrstuvwxyz"
//        let numbers = "0123456789"
        let STR = "____abcdefghijklmnopqrstuvwxyz-0123456789_____";
        let size = 500
        UIGraphicsBeginImageContextWithOptions(CGSize(width: size, height: size), false, 0)
        
        let ctx = UIGraphicsGetCurrentContext()!
        
        
        // draw circle outside
        ctx.setLineWidth(5.0)
        ctx.setStrokeColor(UIColor.blue.cgColor)
        let circleOutsideRect = CGRect(x: 0,y: 0,width: size - 10,height: size - 10)
        ctx.addEllipse(in: circleOutsideRect)
        ctx.strokePath()
        
        // draw circle inside
        let circleRadiusInside = 50
        ctx.setLineWidth(5.0)
        ctx.setStrokeColor(UIColor.blue.cgColor)
        let circleInsideRect = CGRect(x: size/2-circleRadiusInside,y: size/2-circleRadiusInside,width: circleRadiusInside * 2,height: circleRadiusInside * 2)
        ctx.addEllipse(in: circleInsideRect)
        ctx.strokePath()
        // draw all lines
        let ang : CGFloat = 360.0 / CGFloat(str.count)
        let ratio = (size - circleRadiusInside) / 2 / STR.count
        var i : CGFloat = 0.0
        let smallCircleRadius : CGFloat = 3.0
        let blue = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        for ch in str{
            let index = STR.index(of: ch)?.encodedOffset as! Int
            let center = CGPoint(x: size / 2, y: size / 2 )
            let pathIn = UIBezierPath(arcCenter: center, radius: CGFloat(circleRadiusInside), startAngle: (ang * i), endAngle:(ang * i), clockwise: true)
            let inPoint = pathIn.currentPoint
            
            let pathout = UIBezierPath(arcCenter: center, radius: CGFloat(circleRadiusInside + index * ratio), startAngle: (ang * i), endAngle:(ang * i), clockwise: true)
            let outPoint = pathout.currentPoint
            // draw line
            ctx.setLineWidth(1.0)
            ctx.setStrokeColor(UIColor.red.cgColor)
            ctx.move(to: inPoint)
            ctx.addLine(to: outPoint)
            ctx.strokePath()
            // draw small circle
            
            
            let circleInsideRect = CGRect(x: (outPoint.x - smallCircleRadius) ,y: (outPoint.y - smallCircleRadius), width: smallCircleRadius * 2,height: smallCircleRadius * 2)
            
            ctx.setLineWidth(1.0)
            ctx.setStrokeColor(blue.cgColor)
            ctx.setFillColor(blue.cgColor)
            ctx.fillEllipse(in: circleInsideRect)
            
            i += 1.0
        }
        
        
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img
    }
    static func getBLEBeaconDistance(RSSI: NSNumber) -> Double {
        let rssi : Double = RSSI.doubleValue
        if (rssi == 0) {
            return -1.0; // if we cannot determine accuracy, return -1.
        }
        
        let ratio: Double = rssi * 1.0 / (-60.0);
        if (ratio < 1.0) {
            return pow(ratio,10);
        }
        else {
            let accuracy : Double =  (0.89976) * pow(ratio,7.7095) + 0.111;
            return accuracy;
        }
    }
    static func print(id: String, image: UIImage, frame: CGRect, inView: UIView) {
        let printInfo = UIPrintInfo(dictionary:nil)
        printInfo.outputType = .general
        printInfo.jobName = "\(id)"
        
        // Set up print controller
        let printController = UIPrintInteractionController.shared
        printController.printInfo = printInfo
        
        // Assign a UIImage version of my UIView as a printing iten
        printController.printingItem = image
        
        // Do it
        printController.present(from: frame, in: inView, animated: true, completionHandler: nil)
        // Do any additional setup after loading the view.
    }
}
