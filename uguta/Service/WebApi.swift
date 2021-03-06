//
//  File.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 4/29/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

//
//  WebApi.swift
//  ugutaDID
//
//  Created by CO7VF2D1G1HW on 4/29/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
class WebApi{
    static let HOST = "http://96.93.123.233:5000"
    //static let HOST = "http://192.168.1.4:5000"
    //static let HOST = "http://192.168.79.84:5000"
    //static let HOST = "http://192.168.60.67:5000" // wifi
    
    static let GET_CATEGORIES = "\(WebApi.HOST)/api/sellrecognizer/getCategories"
    static let GET_PRODUCT_BY_CATEGORY = "\(WebApi.HOST)/api/sellrecognizer/getProductsByCategory"
    static let GET_DESCRIPTION_BY_QRCODE = "\(WebApi.HOST)/api/sellrecognizer/getDescriptionQRCode"
    static let GET_ITEM_BY_QRCODE = "\(WebApi.HOST)/api/sellrecognizer/getItemByQRCode"
    static let GET_ITEM_BY_ID = "\(WebApi.HOST)/api/sellrecognizer/getItemById?id={id}"
    static let GET_ITEM_INSIDE_STORE = "\(WebApi.HOST)/api/sellrecognizer/getItemInsideStore?storeId={storeId}&position={position}"

    static let LOGIN = "\(WebApi.HOST)/api/sellrecognizer/login"
    static let GET_ITEMS_BY_USERID = "\(WebApi.HOST)/api/sellrecognizer/getItemsByOwnerId"
    static let ADD_ITEM = "\(WebApi.HOST)/api/sellrecognizer/insertItem"
    static let PUBLISH_SELL = "\(WebApi.HOST)/api/sellrecognizer/publishSell"
    static let PAYMENT = "\(WebApi.HOST)/api/sellrecognizer/payment"
    static let UPDATE_USER = "\(WebApi.HOST)/api/sellrecognizer/updateUser"
    static let COMFIRM_RECEIVED = "\(WebApi.HOST)/api/sellrecognizer/confirmReceiveItem"
    static let GET_PRODUCTS_BY_BLUETOOTH_CODES = "\(WebApi.HOST)/api/sellrecognizer/getProductsByBluetoothCodes"
    static let CANCEL_SELL =  "\(WebApi.HOST)/api/sellrecognizer/cancelSell"
    static let GET_STORES =  "\(WebApi.HOST)/api/sellrecognizer/getStores"
    static let GET_STORE_CONTAIN_ITEM =  "\(WebApi.HOST)/api/sellrecognizer/getStoreContainItem?itemId={itemId}"
    static let GET_PRODUCTS_ON_WEB = "\(WebApi.HOST)/api/sellrecognizer/getProductsOnWeb?obj={name}"
    static func manager()-> SessionManager{
//        var defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
//        defaultHeaders["Accept"] = "application/json"
//        defaultHeaders["Content-Type"] = "application/json"
//        let configuration = URLSessionConfiguration.default
//        configuration.httpAdditionalHeaders = defaultHeaders
//        configuration.timeoutIntervalForRequest = 120
//        let sessionManager = Alamofire.SessionManager(configuration: configuration)
//        return sessionManager
        
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        manager.session.configuration.httpAdditionalHeaders?.updateValue("application/json", forKey: "Accept")
        manager.session.configuration.httpAdditionalHeaders?.updateValue("application/json", forKey: "Content-Type")
        return manager
    }
    static func getWeather(lat: Double, lon: Double, completion: @escaping (_ weather:Weather?)->Void){
        let str =   "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&APPID=6435508fad5982cda8c0a812d7a57860&units=metric"
        let url = URL(string: str)
        
        WebApi.manager().request(url!)
            .responseJSON { (data) in
                let weather = Mapper<Weather>().map(JSONObject: data.result.value)
                if let wea = weather {
                    completion(wea)
                }
                else {
                    let str = "{\n    \"coord\": {\n        \"lon\": 108.2,\n        \"lat\": 16.07\n    },\n    \"weather\": [\n        {\n            \"id\": 801,\n            \"main\": \"Clouds\",\n            \"description\": \"few clouds\",\n            \"icon\": \"02d\"\n        }\n    ],\n    \"base\": \"stations\",\n    \"main\": {\n        \"temp\": 34.37,\n        \"pressure\": 1007,\n        \"humidity\": 66,\n        \"temp_min\": 32,\n        \"temp_max\": 36\n    },\n    \"visibility\": 8000,\n    \"wind\": {\n        \"speed\": 5.1,\n        \"deg\": 110\n    },\n    \"clouds\": {\n        \"all\": 20\n    },\n    \"dt\": 1526367600,\n    \"sys\": {\n        \"type\": 1,\n        \"id\": 7978,\n        \"message\": 0.0112,\n        \"country\": \"VN\",\n        \"sunrise\": 1526336236,\n        \"sunset\": 1526382600\n    },\n    \"id\": 1583992,\n    \"name\": \"Turan\",\n    \"cod\": 200\n}"
                    let w = Mapper<Weather>().map(JSONString: str)
                     completion(w)
                }
                
        }
    }
    static func addItem(item: Item, completion: @escaping (_ item: Item? )->Void){
        let json = item.toJSON()
        let url = URL(string: WebApi.ADD_ITEM)
        
        WebApi.manager().request(url!, method: .post, parameters: json, encoding: JSONEncoding.default)
            .responseJSON { (data) in
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) else {
                    completion(nil)
                    return
                }
                
                if(apiModel.Status == 1){
                    let item: Item? = Mapper<Item>().map(JSONObject: apiModel.Data)
                    completion(item)
                }
                else {
                    completion(nil)
                }
                
                
        }
    }
    static func getItemById(id: String, completion: @escaping (_ item: Item? )->Void){
        
        let url = URL(string: WebApi.GET_ITEM_BY_ID.replacingOccurrences(of: "{id}", with: id))
        
        WebApi.manager().request(url!)
            .responseJSON { (data) in
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) else {
                    completion(nil)
                    return
                }
                
                if(apiModel.Status == 1){
                    let item: Item? = Mapper<Item>().map(JSONObject: apiModel.Data)
                    completion(item)
                }
                else {
                    completion(nil)
                }
                
                
        }
    }
    static func getStoreContainItem(itemId: String, completion: @escaping (_ store: Store? )->Void){
        
        let url = URL(string: WebApi.GET_STORE_CONTAIN_ITEM.replacingOccurrences(of: "{itemId}", with: itemId))
        
        WebApi.manager().request(url!)
            .responseJSON { (data) in
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) else {
                    completion(nil)
                    return
                }
                
                if(apiModel.Status == 1){
                    let store: Store? = Mapper<Store>().map(JSONObject: apiModel.Data)
                    completion(store)
                }
                else {
                    completion(nil)
                }
                
                
        }
    }
    static func getItemInsideStore(storeId: String, position: Int, completion: @escaping (_ item: Item? )->Void){
        
        let url = URL(string: WebApi.GET_ITEM_INSIDE_STORE.replacingOccurrences(of: "{storeId}", with: storeId).replacingOccurrences(of: "{position}", with: "\(position)"))
        
        WebApi.manager().request(url!)
            .responseJSON { (data) in
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) else {
                    completion(nil)
                    return
                }
                
                if(apiModel.Status == 1){
                    let item: Item? = Mapper<Item>().map(JSONObject: apiModel.Data)
                    completion(item)
                }
                else {
                    completion(nil)
                }
                
                
        }
    }
    static func getStores(completion: @escaping (_ stores: [Store] )->Void){
        
        let url = URL(string: WebApi.GET_STORES)
        
        WebApi.manager().request(url!)
            .responseJSON { (data) in
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) else {
                    completion([])
                    return
                }
                
                if(apiModel.Status == 1){
                    let stores: [Store] = Mapper<Store>().mapArray(JSONObject: apiModel.Data) ?? []
                    completion(stores)
                }
                else {
                    completion([])
                }
                
                
        }
    }
    static func getDescriptionQRCode(code: String, completion: @escaping (_ description: String )->Void){
        let parameters: Parameters = [
            "code": code
            ]
        let url = URL(string: WebApi.GET_DESCRIPTION_BY_QRCODE)
        
        WebApi.manager().request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { (data) in
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) else {
                    completion("Error")
                    return
                }
                
                if(apiModel.Status == 1){
                    let description = apiModel.Data as! String
                    
                    completion(description)
                }
                else {
                    completion("Error")
                }
                
        }
    }
    
    
    /*var userId = data.id;
     var user = data.user;*/
    
    static func updateUser(user: User, completion: @escaping (_ done: Bool )->Void){
        let parameters: Parameters = [
            "id": user.id,
            "user": user.toJSON()
        ]
        let url = URL(string: WebApi.UPDATE_USER)
        
        WebApi.manager().request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { (data) in
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) else {
                    completion(false)
                    return
                }
                
                if(apiModel.Status == 1){
                    
                    completion(true)
                }
                else {
                    completion(false)
                }
                
        }
    }
    
    static func payment(itemId: String, userInfo: History, completion: @escaping (_ item: Item? )->Void){
        let parameters: Parameters = [
            "itemId": itemId,
            "buyerInfo": userInfo.toJSON()
        ]
        let url = URL(string: WebApi.PAYMENT)
        
        WebApi.manager().request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { (data) in
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) else {
                    completion(nil)
                    return
                }
                
                if(apiModel.Status == 1){
                    let dic = apiModel.Data as! NSDictionary
                    let item : Item = dic.cast()!
                    completion(item)
                }
                else {
                    completion(nil)
                }
                
        }
    }
    static func publishSell(itemId: String, ownerInfo: History, completion: @escaping (_ item: Item? )->Void){
        let parameters: Parameters = [
            "itemId": itemId,
            "userInfo": ownerInfo.toJSON()
        ]
        let url = URL(string: WebApi.PUBLISH_SELL)
        
        WebApi.manager().request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { (data) in
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) else {
                    completion(nil)
                    return
                }
                
                if(apiModel.Status == 1){
                     let dic = apiModel.Data as! NSDictionary
                    let item : Item = dic.cast()!
                    completion(item)
                }
                else {
                    completion(nil)
                }
                
        }
    }
    
    static func cancelSell(itemId: String,completion: @escaping (_ done: Bool )->Void){
        
        let url = URL(string: "\(WebApi.CANCEL_SELL)?id=\(itemId)")
        
        WebApi.manager().request(url!)
            .responseJSON { (data) in
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) else {
                    completion(false)
                    return
                }
                
                if(apiModel.Status == 1){
                    completion(true)
                }
                else {
                    completion(false)
                }
                
        }
    }
    static func confirmReceived(itemId: String,completion: @escaping (_ done: Bool )->Void){
        
        let url = URL(string: "\(WebApi.COMFIRM_RECEIVED)?id=\(itemId)")
        
        WebApi.manager().request(url!)
            .responseJSON { (data) in
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) else {
                    completion(false)
                    return
                }
                
                if(apiModel.Status == 1){
                    completion(true)
                }
                else {
                    completion(false)
                }
                
        }
    }
    static func login(phone: String, password: String,completion: @escaping (_ user: User? )->Void){
       
        let url = URL(string: "\(WebApi.LOGIN)?phone=\(phone.replacingOccurrences(of: "+", with: "%2B"))&password=\(password)")
      
        WebApi.manager().request(url!)
            .responseJSON { (data) in
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) else {
                    completion(nil)
                    return
                }
                
                if(apiModel.Status == 1){
                    let dic = apiModel.Data as! NSDictionary
                    let user : User = dic.cast()!
                    completion(user)
                }
                else {
                    completion(nil)
                }
                
        }
    }
    static func getItemByQRCode(code: String, coord: Coord, completion: @escaping (_ item: Item? )->Void){
        let parameters: Parameters = [
            "code": code,
            "coord": coord.toJSON()
        ]
        let url = URL(string: WebApi.GET_ITEM_BY_QRCODE)
        
        WebApi.manager().request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { (data) in
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) else {
                    completion(nil)
                    return
                }
                
                if(apiModel.Status == 1){                    
                    let i : Item? = Mapper<Item>().map(JSONObject: apiModel.Data)
                    completion(i)
                }
                else {
                    completion(nil)
                }
                
        }
    }
    
    static func getCategories(completion: @escaping (_ list:[Category])->Void){
        
        let url = URL(string: WebApi.GET_CATEGORIES)
        
        WebApi.manager().request(url!)
            .responseJSON { (data) in
                
                
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) else {
                    completion([])
                    return
                }
                
                if(apiModel.Status == 1){
                    let arr = apiModel.Data as! [Any]
                    var categories : [Category] = []
                    for jsonItem in arr{
                        let strJSON = jsonItem as! NSDictionary
                        let category : Category = strJSON.cast()!
                        categories.append(category)
                    }
                    completion(categories)
                }
                else {
                    completion([])
                }
                
        }
    }
    
    static func getProductsByBluetoothCodes(devices: [BLEDevice], coord: Coord, completion: @escaping (_ list:[Item])->Void){
        
        let url = URL(string: WebApi.GET_PRODUCTS_BY_BLUETOOTH_CODES)
        let parameters: Parameters = [
            "devices": devices.toJSON(),
            "coord" : coord.toJSON()
        ]
        WebApi.manager().request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { (data) in
                
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) else {
                    completion([])
                    return
                }
                
                if(apiModel.Status == 1){
                    let items : [Item] = Mapper<Item>().mapArray(JSONObject:apiModel.Data)!                   
                    completion(items)
                }
                else {
                    completion([])
                }
                
        }
    }
    
    static func getProductsByCategory(categoryId: String, completion: @escaping (_ list:[Item])->Void){
        let url = URL(string: "\(WebApi.GET_PRODUCT_BY_CATEGORY)?categoryId=\(categoryId)&pageNum=1&pageSize=10000")
        WebApi.manager().request(url!)
            .responseJSON { (data) in
                
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) else {
                    completion([])
                    return
                }
                
                if(apiModel.Status == 1){
                    let arr = apiModel.Data as! [Any]
                    var items : [Item] = []
                    for jsonItem in arr{
                        let strJSON = jsonItem as! NSDictionary
                        let item : Item = strJSON.cast()!
                        items.append(item)
                    }
                    completion(items)
                }
                else {
                    completion([])
                }
                
        }
    }
    static func getItemsByOwnerId(userId: String, completion: @escaping (_ list:[Item])->Void){
        let url = URL(string: "\(WebApi.GET_ITEMS_BY_USERID)?ownerId=\(userId)&pageNum=1&pageSize=10000")
        WebApi.manager().request(url!)
            .responseJSON { (data) in
                
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) else {
                    completion([])
                    return
                }
                
                if(apiModel.Status == 1){
                    let arr = apiModel.Data as! [Any]
                    var items : [Item] = []
                    for jsonItem in arr{
                        let strJSON = jsonItem as! NSDictionary
                        let item : Item = strJSON.cast()!
                        items.append(item)
                    }
                    completion(items)
                }
                else {
                    completion([])
                }
                
        }
    }
    static func getProductSearch(name:String, completion: @escaping (_ list:[ProductSearch])->Void){
        let originalString = WebApi.GET_PRODUCTS_ON_WEB.replacingOccurrences(of: "{name}", with: name)
        let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)

        let url = URL(string: escapedString!)
        
        WebApi.manager().request(url!)
            .responseJSON { (data) in
                
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) else {
                    completion([])
                    return
                }
                
                if(apiModel.Status == 1){
                    let products: [ProductSearch] = Mapper<ProductSearch>().mapArray(JSONObject: apiModel.Data) ?? []
                    completion(products)
                }
                else {
                    completion([])
                }
                
        }
    }
    static func getImage(url : String, completion: @escaping (_ image:UIImage?)->Void){
        if url == ""{
            completion(nil)
        }
        else {
            DispatchQueue.global().async {
                let u = URL(string:  url)
                let data = try? Data(contentsOf: u!)
                DispatchQueue.main.async { () -> Void in
                    
                    completion(UIImage(data: data!))
                }
            }
        }
    }

}

