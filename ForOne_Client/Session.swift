//
//  Session.swift
//  ForOne_Client
//
//  Created by GAN-mac on 16/5/31.
//  Copyright © 2016年 gan. All rights reserved.
//

import Foundation
import UIKit



class Session{
    
    class func session(action:String = "",body:[String:String],closure: (success:Bool, result:[String:String]? , reason:String?) -> ()) {
        
        do{
            let requestData=try NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions.PrettyPrinted)
            let requestStr = String(data: requestData, encoding: NSUTF8StringEncoding)!
            
            let urlStr = workhost + action
            let url = NSURL(string: urlStr)
            let request = NSMutableURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 120)
            request.HTTPMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = requestStr.dataUsingEncoding(NSUTF8StringEncoding)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request){
                
                data, response, error in
                
                //切换到主线程
                dispatch_async(dispatch_get_main_queue()){
                    guard error == nil else{
                        closure(success: false, result: nil, reason: "连接错误")
                        return
                    }
                    
                    do{
                        guard let result = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? [String:AnyObject] else{
                            closure(success: false, result: nil, reason: "数据错误")
                            return
                        }
                        
                        /*
                         通过response["result"]判断后台返回数据是否合法
                         result == 1 ------true
                         result == 0 ------false
                         */
                    
                        if result["result"] as! Bool{
                            
                            var swiftResult = [String:String]()
                            for (key,value) in result["data"] as! [String:AnyObject]{
                                swiftResult[key] = String(value)
                            }
                            print("url session data: result = \(swiftResult)")
                            
                            closure(success: true, result: swiftResult, reason: nil)
                        }else{
                            closure(success: false, result: nil, reason: String(result["reason"]!))
                            print("url session data: reason = \(String(result["reason"]!))")
                        }
                        
                        
                        
                    }catch let responseError{
                        print("response数据处理错误: \(responseError)")
                    }
                }
            }
            
            task.resume()
        }catch let error{
            print("request数据处理错误: \(error)")
        }
    }
    
    class func upload(image:UIImage, closure:(success:Bool) -> ()){
        
        let urlStr = homehost + "/use/head"
        let url = NSURL(string: urlStr)
        let request = NSMutableURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 120)
        request.addValue("image/png", forHTTPHeaderField: "Content-Type")
        request.addValue("text/html", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        
        let imageData = UIImagePNGRepresentation(image)
        
        let session = NSURLSession.sharedSession()
        let task = session.uploadTaskWithRequest(request, fromData: imageData!){
            data,response,error in
            
            dispatch_async(dispatch_get_main_queue()){
                
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
        }
        task.resume()
    }
}