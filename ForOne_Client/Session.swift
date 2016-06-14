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
            let requestStr = String(data: requestData, encoding: NSUTF8StringEncoding)!
            
            let urlStr = host + action

            let url = NSURL(string: urlStr)
            let request = NSMutableURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 10)
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
    
    class func upload(image:UIImage, userid:Int32, closure:(success:Bool) -> ()){
        
        //拼接字符串
        let boundaryStr = "--"
        let randomIDStr = "----------foronephoto---------"
        let uploadID = "uploadFile"
        
        func topStringWithMimeType(mimeType:String,uploadFile:String) -> String{
            let strM = NSMutableString()
            strM.appendString("\(boundaryStr)\(randomIDStr)\n")
            strM.appendString("Content-Disposition: form-data; name=\"\(uploadID)\"; filename=\"\(uploadFile)\"\n")
            strM.appendString("Content-Type: \(mimeType)\n\n")
            return strM as String
        }
        
        func bottomString() -> String{
            let strM = NSMutableString()
            strM.appendString("\(boundaryStr)\(randomIDStr)\n")
            strM.appendString("Content-Disposition: form-data; name=\"submit\"\n\n")
            strM.appendString("Submit\n")
            strM.appendString("\(boundaryStr)\(randomIDStr)--\n")
            return strM as String
        }
        
        do{
            let data = UIImagePNGRepresentation(image)!
            
            //1.数据体
            let topStr:NSString = topStringWithMimeType("image/png", uploadFile: "fo\(userid).png")
            let bottomStr:NSString = bottomString()
            
            let dataM = NSMutableData()
            dataM.appendData(topStr.dataUsingEncoding(NSUTF8StringEncoding)!)
            dataM.appendData(data)
            dataM.appendData(bottomStr.dataUsingEncoding(NSUTF8StringEncoding)!)
            
            //2.Request
            let urlStr = host + Action.setPhoto
            let url = NSURL(string: urlStr)
            
            let request = NSMutableURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 2.0)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPMethod = "POST"
            request.HTTPBody = dataM
            
            let strLength = "\(data.length)"
            request.setValue(strLength, forHTTPHeaderField: "Content-Length")
            
            let strContentType = "multipart/form-data; boundary=\(randomIDStr)"
            request.setValue(strContentType, forHTTPHeaderField: "Content-Type")
            
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request){
                data,response,error in
                
                dispatch_async(dispatch_get_main_queue()){
                    
                    guard error == nil else{
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
        }catch let error{
            print("request数据处理错误: \(error)")
        }
    }
}