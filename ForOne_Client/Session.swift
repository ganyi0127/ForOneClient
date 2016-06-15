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
    
    class func session(action:String = "",body:[String:AnyObject],closure: (success:Bool, result:[String:String]? , reason:String?) -> ()) {
        
        do{
            let requestData=try NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions.PrettyPrinted)
            
            let urlStr = host + action

            let url = NSURL(string: urlStr)
            let request = NSMutableURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 10)
            request.HTTPMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = requestData
    
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
                        print("返回:\(result)")
                    
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
    
    class func upload(image:UIImage, userid:Int32, closure:(success:Bool, result:[String:String]? , reason:String?) -> ()){
        
        //1.数据体
        let data = UIImagePNGRepresentation(image)!
        
        //2.Request
        let urlStr = host + Action.setPhoto + "?userid=\(userid)"
        let url = NSURL(string: urlStr)
        
        let request = NSMutableURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 2.0)
        request.HTTPMethod = "POST"
        request.addValue("image/png", forHTTPHeaderField: "Content-Type")
        
        let session = NSURLSession.sharedSession()
        let task = session.uploadTaskWithRequest(request, fromData: data){
            data,response,error in
            
            dispatch_async(dispatch_get_main_queue()){
                
                guard error == nil else{
                    closure(success: false,result: nil, reason: "上传失败")
                    return
                }
                
                do{
                    guard let result:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary else{
                        closure(success: false,result: nil, reason: "数据错误")
                        return
                    }
                    print("result: \(result)")
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
    }
}