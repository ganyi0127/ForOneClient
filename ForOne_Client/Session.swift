//
//  Session.swift
//  ForOne_Client
//
//  Created by GAN-mac on 16/5/31.
//  Copyright © 2016年 gan. All rights reserved.
//

import Foundation
import UIKit
let localhost = "http://192.168.1.101:8080"
let nethost = "http://127.0.0.1:8080"
//import Alamofire

class Session{
    
    class func session(action:String = "",body:[String:String],closure: (success:Bool, response:[String:String]) -> ()) {
        print("body: \(body)")
        do{
            let requestData=try NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions.PrettyPrinted)
            let requestStr = String(data: requestData, encoding: NSUTF8StringEncoding)!
            
            let urlStr = localhost + action
            let url = NSURL(string: urlStr)
            let request = NSMutableURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 120)
            request.HTTPMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = requestStr.dataUsingEncoding(NSUTF8StringEncoding)
            print("requestStr: \(requestStr)")
            print("request: \(request)")
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request){
                
                data, response, error in
                
                print("data0: \(data)\nresponse0: \(response)\nerror0: \(error)")
                guard error == nil else{
                    closure(success: false, response: [:])
                    return
                }
                
                do{
                    print("data:\(data!)")
                    guard let result:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary else{
                        closure(success: false, response: [:])
                        return
                    }
                    print("result: \(result)")
                    var response = [String:String]()
                    for element in result{
                        print("element: key:\(element.key) value: \(element.value)")
                        response[String(element.key)] = String(element.value)
                    }
                    print("response: \(response)")
                    closure(success: true, response: response)
                    
                }catch let responseError{
                    print("response数据处理错误: \(responseError)")
                }
            }
            
            task.resume()
        }catch let error{
            print("request数据处理错误: \(error)")
        }
    }
    
    class func upload(image:UIImage, closure:(success:Bool) -> ()){
        
        let urlStr = localhost + "/use/head"
        let url = NSURL(string: urlStr)
        let request = NSMutableURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 120)
        request.addValue("image/png", forHTTPHeaderField: "Content-Type")
        request.addValue("text/html", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        
        let imageData = UIImagePNGRepresentation(image)
        
        let session = NSURLSession.sharedSession()
        let task = session.uploadTaskWithRequest(request, fromData: imageData!){
            data,response,error in
            guard error != nil else{
                closure(success: false)
                return
            }
            
            do{
                guard let result:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary else{
                    closure(success: false)
                    return
                }
                print("result: \(result)")
                var response = [String:String]()
                for element in result{
                    response[element.key as! String] = element.value as? String
                }
                
                closure(success: true)
                
            }catch let responseError{
                print("response数据处理错误: \(responseError)")
            }
        }
        task.resume()
    }
}