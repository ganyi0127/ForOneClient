//
//  Session.swift
//  ForOne_Client
//
//  Created by GAN-mac on 16/5/31.
//  Copyright © 2016年 gan. All rights reserved.
//

import Foundation
import UIKit
let localhost = "http://localhost:8080"
let nethost = "http://127.0.0.1"
//import Alamofire

class Session{
    
    class func session(action:String = "",body:[String:String],closure: (success:Bool, response:[String:String]) -> ()) {
        
        do{
            let requestData=try NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions.PrettyPrinted)
            let requestStr = String(data: requestData, encoding: NSUTF8StringEncoding)!
            
            let urlStr = localhost + action
            let url = NSURL(string: urlStr)
            let request = NSMutableURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 120)
            request.HTTPMethod = "post"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = requestStr.dataUsingEncoding(NSUTF8StringEncoding)
            
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request){
                
                data, response, error in
                
                guard error != nil else{
                    closure(success: false, response: [:])
                    return
                }
                
                do{
                    guard let result:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary else{
                        closure(success: false, response: [:])
                        return
                    }
                    
                    var response = [String:String]()
                    for element in result{
                        response[element.key as! String] = element.value as? String
                    }
                    
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